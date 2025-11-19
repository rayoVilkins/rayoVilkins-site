import cloudscraper # Import cloudscraper instead of requests
import json
import sqlite3
from datetime import datetime
import time
import os

# Configuration
# Ensure DB_PATH is set as an environment variable in your GitHub Action,
# or it will default to 'build/proclubs.db'
DB_PATH = os.environ.get('DB_PATH', 'build/proclubs.db')
YOUR_CLUB_ID = '19798' # This is already in your URL, but good to have as a variable
PLATFORM = 'common-gen5' # e.g., 'common-gen5', 'ps4', 'ps5', 'xboxone', 'xbox-series-xs', 'pc'
MAX_RESULTS = 20 # Increased from 10 just in case, can be tuned

# Multiple endpoints for different match types
ENDPOINTS = [
    {
        'name': 'League Matches',
        'url': f'https://proclubs.ea.com/api/fc/clubs/matches?platform={PLATFORM}&clubIds={YOUR_CLUB_ID}&matchType=leagueMatch&maxResultCount={MAX_RESULTS}'
    },
    {
        'name': 'Playoff Matches',
        'url': f'https://proclubs.ea.com/api/fc/clubs/matches?platform={PLATFORM}&clubIds={YOUR_CLUB_ID}&matchType=playoffMatch&maxResultCount={MAX_RESULTS}'
    },
    {
        'name': 'Cup Matches', # Added Cup matches as another potential source
        'url': f'https://proclubs.ea.com/api/fc/clubs/matches?platform={PLATFORM}&clubIds={YOUR_CLUB_ID}&matchType=cupMatch&maxResultCount={MAX_RESULTS}'
    }
]

# Create a scraper instance. This is the main change.
# This scraper will handle JavaScript challenges and present itself as a real browser.
scraper = cloudscraper.create_scraper(
    browser={
        'browser': 'chrome',
        'platform': 'windows',
        'mobile': False
    }
)

def fetch_matches_from_api(endpoint_name, url):
    """Fetch matches from EA API using cloudscraper to bypass WAFs like Akamai"""

    # We keep these headers as a good starting point, cloudscraper will add/modify them
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Accept-Language': 'en-US,en;q=0.9',
        'Referer': f'https://proclubs.ea.com/my-club/{YOUR_CLUB_ID}/overview?platform={PLATFORM}',
        'Origin': 'https://proclubs.ea.com',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
    }

    for attempt in range(3):
        try:
            print(f"  Fetching {endpoint_name} (attempt {attempt + 1}/3)...")
            timeout = 30 + (attempt * 10)

            # Use scraper.get() instead of requests.get()
            response = scraper.get(url, headers=headers, timeout=timeout)
            
            response.raise_for_status() # This will raise an HTTPError for 4xx/5xx responses
            data = response.json()
            print(f"  ✓ Successfully fetched {len(data)} {endpoint_name}")
            return data

        except Exception as e:
            # Catching a broader exception range as cloudscraper can have different errors
            print(f"    Error on attempt {attempt + 1}: {e}")
            if "Forbidden" in str(e) or "403" in str(e):
                print("    Still getting 403 Forbidden. Akamai block is persistent.")
            
            if attempt < 2:
                time.sleep(5) # Increase sleep time for retries
                continue
            else:
                print(f"  ✗ Failed to fetch {endpoint_name} after 3 attempts.")
                return None

    return None

def connect_db():
    """Connect to SQLite database"""
    # Ensure the directory exists
    db_dir = os.path.dirname(DB_PATH)
    if db_dir and not os.path.exists(db_dir):
        print(f"Creating database directory: {db_dir}")
        os.makedirs(db_dir)
        
    print(f"Connecting to database at: {DB_PATH}")
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def match_exists(conn, match_id):
    """Check if match already exists in database"""
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM matches WHERE match_id = ?", (match_id,))
    return cursor.fetchone() is not None

def safe_get(data, key, default=None):
    """Safely get a value from a nested dict, handling None intermediate keys."""
    if not isinstance(data, dict):
        return default
    keys = key.split('.')
    value = data
    for k in keys:
        if value is None or not isinstance(value, dict):
            return default
        value = value.get(k)
    return value if value is not None else default

def insert_match_.py
data(conn, match):
    """Insert a single match and all related data using INSERT OR IGNORE"""
    match_id = safe_get(match, 'matchId')
    if not match_id:
        print("    ⚠️ Skipping match with no matchId")
        return False
    
    if match_exists(conn, match_id):
        return False

    cursor = conn.cursor()

    try:
        # 1. Insert into matches table
        cursor.execute("""
            INSERT OR IGNORE INTO matches (match_id, match_timestamp, time_ago_number, time_ago_unit, raw_json)
            VALUES (?, ?, ?, ?, ?)
        """, (
            match_id,
            safe_get(match, 'timestamp'),
            safe_get(match, 'timeAgo.number'),
            safe_get(match, 'timeAgo.unit'),
            json.dumps(match) # Store the raw JSON for future-proofing
        ))

        # Check if match was actually inserted
        if cursor.rowcount == 0:
            return False # Should have been caught by match_exists, but good to double-check

        # 2. Process each club in the match
        for club_id, club_data in safe_get(match, 'clubs', {}).items():
            if not club_data: continue # Skip if club_data is empty
            
            cursor.execute("""
                INSERT OR IGNORE INTO match_clubs (
                    match_id, club_id, club_name, date, game_number, goals, goals_against,
                    losses, match_type, result, score, season_id, team_id, ties,
                    winner_by_dnf, wins, region_id, stad_name, kit_id, crest_asset_id, custom_kit_json
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id, club_id,
                safe_get(club_data, 'details.name'),
                safe_get(club_data, 'date'),
                safe_get(club_data, 'gameNumber'),
                int(safe_get(club_data, 'goals', 0)),
                int(safe_get(club_data, 'goalsAgainst', 0)),
                int(safe_get(club_data, 'losses', 0)),
                int(safe_get(club_data, 'matchType', 0)),
                int(safe_get(club_data, 'result', 0)),
                int(safe_get(club_data, 'score', 0)),
                safe_get(club_data, 'season_id'),
                safe_get(club_data, 'TEAM'), # Note: This key is often 'teamId' in other APIs, check raw JSON if issues
                int(safe_get(club_data, 'ties', 0)),
                int(safe_get(club_data, 'winnerByDnf', 0)),
                int(safe_get(club_data, 'wins', 0)),
                safe_get(club_data, 'details.regionId'),
                safe_get(club_data, 'details.customKit.stadName'),
                safe_get(club_data, 'details.customKit.kitId'),
                safe_get(club_data, 'details.customKit.crestAssetId'),
                json.dumps(safe_get(club_data, 'details.customKit', {}))
            ))

            # Update clubs table
            cursor.execute("""
                INSERT OR REPLACE INTO clubs (club_id, club_name, region_id, team_id, stad_name, crest_asset_id, last_seen)
                VALUES (?, ?, ?, ?, ?, ?, datetime('now'))
            """, (
                club_id,
                safe_get(club_data, 'details.name'),
                safe_get(club_data, 'details.regionId'),
                safe_get(club_data, 'details.teamId'), # Using 'teamId' here
                safe_get(club_data, 'details.customKit.stadName'),
                safe_get(club_data, 'details.customKit.crestAssetId')
            ))

        # 3. Process players
        for club_id, players in safe_get(match, 'players', {}).items():
            for player_id, player_data in players.items():
                if not player_data: continue # Skip if player_data is empty
                
                cursor.execute("""
                    INSERT OR IGNORE INTO match_players (
                        match_id, club_id, player_id, player_name, assists, cleansheetsany,
                        cleansheetsdef, cleansheetsgk, goals, goalsconceded, losses, mom,
                        namespace, passattempts, passesmade, pos, rating, realtimegame,
                        realtimeidle, redcards, saves, score, shots, tackleattempts,
                        tacklesmade, wins, vproattr, vprohackreason
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    match_id, club_id, player_id,
                    safe_get(player_data, 'playername'),
                    int(safe_get(player_data, 'assists', 0)),
                    int(safe_get(player_data, 'cleansheetsany', 0)),
                    int(safe_get(player_data, 'cleansheetsdef', 0)),
                    int(safe_get(player_data, 'cleansheetsgk', 0)),
                    int(safe_get(player_data, 'goals', 0)),
                    int(safe_get(player_data, 'goalsconceded', 0)),
                    int(safe_get(player_data, 'losses', 0)),
                    int(safe_get(player_data, 'mom', 0)),
                    int(safe_get(player_data, 'namespace', 0)),
                    int(safe_get(player_data, 'passattempts', 0)),
                    int(safe_get(player_data, 'passesmade', 0)),
                    safe_get(player_data, 'pos'),
                    float(safe_get(player_data, 'rating', 0.0)), # Ensure float
                    int(safe_get(player_data, 'realtimegame', 0)),
                    int(safe_get(player_data, 'realtimeidle', 0)),
                    int(safe_get(player_data, 'redcards', 0)),
                    int(safe_get(player_data, 'saves', 0)),
                    int(safe_get(player_data, 'SCORE', 0)), # Note: Key is 'SCORE'
                    int(safe_get(player_data, 'shots', 0)),
                    int(safe_get(player_data, 'tackleattempts', 0)),
                    int(safe_get(player_data, 'tacklesmade', 0)),
                    int(safe_get(player_data, 'wins', 0)),
                    safe_get(player_data, 'vproattr'),
                    safe_get(player_data, 'vprohackreason')
                ))

                # Update players table
                cursor.execute("""
                    INSERT OR REPLACE INTO players (player_id, player_name, last_position, last_club_id, last_seen)
                    VALUES (?, ?, ?, ?, datetime('now'))
                """, (
                    player_id,
                    safe_get(player_data, 'playername'),
                    safe_get(player_data, 'pos'),
                    club_id
                ))

        # 4. Process aggregates
        for club_id, agg_data in safe_get(match, 'aggregate', {}).items():
            if not agg_data: continue # Skip if agg_data is empty
            
            cursor.execute("""
                INSERT OR IGNORE INTO match_aggregates (
                    match_id, club_id, assists, cleansheetsany, cleansheetsdef, cleansheetsgk,
                    goals, goalsconceded, losses, mom, namespace, passattempts, passesmade,
                    pos, rating, realtimegame, realtimeidle, redcards, saves, score, shots,
                    tackleattempts, tacklesmade, vproattr, vprohackreason, wins
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id, club_id,
                int(safe_get(agg_data, 'assists', 0)),
                int(safe_get(agg_data, 'cleansheetsany', 0)),
                int(safe_get(agg_data, 'cleansheetsdef', 0)),
                int(safe_get(agg_data, 'cleansheetsgk', 0)),
                int(safe_get(agg_data, 'goals', 0)),
                int(safe_get(agg_data, 'goalsconceded', 0)),
                int(safe_get(agg_data, 'losses', 0)),
                int(safe_get(agg_data, 'mom', 0)),
                int(safe_get(agg_data, 'namespace', 0)),
                int(safe_get(agg_data, 'passattempts', 0)),
                int(safe_get(agg_data, 'passesmade', 0)),
                safe_get(agg_data, 'pos'),
                float(safe_get(agg_data, 'rating', 0.0)), # Ensure float
                int(safe_get(agg_data, 'realtimegame', 0)),
                int(safe_get(agg_data, 'realtimeidle', 0)),
                int(safe_get(agg_data, 'redcards', 0)),
                int(safe_get(agg_data, 'saves', 0)),
                int(safe_get(agg_data, 'SCORE', 0)), # Note: Key is 'SCORE'
                int(safe_get(agg_data, 'shots', 0)),
                int(safe_get(agg_data, 'tackleattempts', 0)),
                int(safe_get(agg_data, 'tacklesmade', 0)),
                safe_get(agg_data, 'vproattr'),
                safe_get(agg_data, 'vprohackreason'),
                int(safe_get(agg_data, 'wins', 0))
            ))

        conn.commit()
        return True

    except sqlite3.Error as e:
        conn.rollback()
        print(f"    ⚠️ Database error for match {match_id}: {e}")
        return False
    except Exception as e:
        conn.rollback()
        print(f"    ⚠️ General error inserting match {match_id}: {e}")
        # Optionally, log the full 'match' object here to debug problematic data
        # print(json.dumps(match, indent=2))
        return False

def main():
    """Main function to fetch and store matches from multiple endpoints"""
    print("="*50)
    print("PRO CLUBS MATCH DATA FETCHER")
    print(f"Database Path: {DB_PATH}")
    print("="*50)

    try:
        conn = connect_db()
    except sqlite3.Error as e:
        print(f"❌ CRITICAL: Failed to connect to database: {e}")
        return

    total_new_matches = 0
    total_existing_matches = 0
    all_matches_count = 0

    # Fetch from each endpoint
    for endpoint in ENDPOINTS:
        print(f"\n📡 Fetching {endpoint['name']}...")
        matches = fetch_matches_from_api(endpoint['name'], endpoint['url'])

        if not matches:
            print(f"  ❌ No data fetched for {endpoint['name']}")
            continue
            
        if not isinstance(matches, list):
            print(f"  ❌ Expected a list of matches from {endpoint['name']}, but got {type(matches)}")
            continue

        all_matches_count += len(matches)
        new_matches = 0
        existing_matches = 0

        print(f"  📝 Processing {len(matches)} matches...")
        for match in matches:
            if insert_match_data(conn, match):
                new_matches += 1
                # Reduced logging noise, uncomment to see every match
                # print(f"    ✅ Match {match['matchId']} added")
            else:
                existing_matches += 1
                # print(f"    ⏭️ Match {match['matchId']} already exists")

        print(f"  📊 {endpoint['name']} Summary: {new_matches} new, {existing_matches} existing")
        total_new_matches += new_matches
        total_existing_matches += existing_matches
        
    if all_matches_count > 0:
        # Log the fetch only if we actually found matches
        try:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO fetch_history (matches_found, new_matches_added, status)
                VALUES (?, ?, ?)
            """, (
                all_matches_count,
                total_new_matches,
                'success'
            ))
            conn.commit()
        except sqlite3.Error as e:
            print(f"  ⚠️ Could not write to fetch_history: {e}")

    # Get total matches in database
    total_in_db = 0
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT COUNT(*) as count FROM matches")
        result = cursor.fetchone()
        if result:
            total_in_db = result['count']
    except sqlite3.Error as e:
        print(f"  ⚠️ Could not get total match count from DB: {e}")
    
    conn.close()

    print("\n" + "="*50)
    print("📈 OVERALL SUMMARY:")
    print(f"  Total matches found: {all_matches_count}")
    print(f"  New matches added: {total_new_matches}")
    print(f"  Existing matches skipped: {total_existing_matches}")
    print(f"  Total matches in database: {total_in_db}")
    print("="*50)

if __name__ == "__main__":
    main()
