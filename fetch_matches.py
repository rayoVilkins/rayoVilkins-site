import asyncio
import json
import sqlite3
from datetime import datetime
import os

import zendriver as zd

# Configuration
DB_PATH = os.environ.get('DB_PATH', 'build/proclubs.db')
YOUR_CLUB_ID = '19798'

# Multiple endpoints for different match types
ENDPOINTS = [
    {
        'name': 'League Matches',
        'url': 'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds=19798&matchType=leagueMatch&maxResultCount=10'
    },
    {
        'name': 'Playoff Matches', 
        'url': 'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds=19798&matchType=playoffMatch&maxResultCount=10'
    }
]

async def fetch_matches_from_api(endpoint_name, url, browser):
    """Fetch matches from EA API using Zendriver with proper headers"""
    
    print(f"  Fetching {endpoint_name}...")
    
    try:
        # Create a new page
        page = await browser.get(url)
        
        # Wait for the page to load and get the response
        await asyncio.sleep(3)  # Give it time to load
        
        # Get the page content (should be JSON)
        content = await page.get_content()
        
        # Parse the JSON from the page content
        # The content might be wrapped in HTML, so we need to extract the JSON
        if '<pre>' in content:
            # If it's wrapped in a pre tag, extract it
            start = content.find('<pre>') + 5
            end = content.find('</pre>')
            json_text = content[start:end]
        elif content.strip().startswith('[') or content.strip().startswith('{'):
            # If it's raw JSON
            json_text = content
        else:
            # Try to find JSON in the body
            import re
            json_match = re.search(r'(\[.*\]|\{.*\})', content, re.DOTALL)
            if json_match:
                json_text = json_match.group(1)
            else:
                print(f"  ✗ Could not find JSON in response for {endpoint_name}")
                return None
        
        data = json.loads(json_text)
        print(f"  ✓ Successfully fetched {len(data)} {endpoint_name}")
        return data
        
    except Exception as e:
        print(f"  ✗ Error fetching {endpoint_name}: {e}")
        return None

def connect_db():
    """Connect to SQLite database"""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def match_exists(conn, match_id):
    """Check if match already exists in database"""
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM matches WHERE match_id = ?", (match_id,))
    return cursor.fetchone() is not None

def insert_match_data(conn, match):
    """Insert a single match and all related data using INSERT OR IGNORE"""
    match_id = match['matchId']
    
    if match_exists(conn, match_id):
        return False
    
    cursor = conn.cursor()
    
    try:
        # 1. Insert match header
        cursor.execute("""
            INSERT INTO matches (match_id, match_timestamp)
            VALUES (?, ?)
        """, (match_id, match.get('timestamp', 0)))
        
        # 2. Insert club data for both clubs
        for club_data in match.get('clubs', {}).values():
            club_id = club_data.get('clubId')
            if not club_id:
                continue
                
            # Insert/update club reference
            cursor.execute("""
                INSERT INTO clubs (club_id, club_name, region_id, team_id, crest_asset_id, last_seen)
                VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
                ON CONFLICT(club_id) DO UPDATE SET
                    club_name = excluded.club_name,
                    region_id = excluded.region_id,
                    team_id = excluded.team_id,
                    crest_asset_id = excluded.crest_asset_id,
                    last_seen = CURRENT_TIMESTAMP
            """, (
                club_id,
                club_data.get('name', ''),
                club_data.get('regionId', ''),
                club_data.get('teamId', ''),
                club_data.get('customKit', {}).get('crestAssetId', '')
            ))
            
            # Insert match_clubs data
            cursor.execute("""
                INSERT OR IGNORE INTO match_clubs 
                (match_id, club_id, club_name, goals, goals_against, result, 
                 match_type, winner_by_dnf, team_id)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id, club_id,
                club_data.get('name', ''),
                club_data.get('goals', 0),
                club_data.get('goalsAgainst', 0),
                club_data.get('result', 0),
                match.get('matchType', ''),
                club_data.get('winnerByDnf', 0),
                club_data.get('teamId', '')
            ))
            
            # 3. Insert player data
            for player_id, player_data in club_data.get('players', {}).items():
                # Insert/update player reference
                cursor.execute("""
                    INSERT INTO players (player_id, player_name, last_position, last_club_id, last_seen)
                    VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
                    ON CONFLICT(player_id) DO UPDATE SET
                        player_name = excluded.player_name,
                        last_position = excluded.last_position,
                        last_club_id = excluded.last_club_id,
                        last_seen = CURRENT_TIMESTAMP
                """, (
                    player_id,
                    player_data.get('playername', ''),
                    player_data.get('position', ''),
                    club_id
                ))
                
                # Insert match_players data
                cursor.execute("""
                    INSERT OR IGNORE INTO match_players
                    (match_id, club_id, player_id, player_name, goals, assists,
                     clean_sheet_def, clean_sheet_gk, goals_conceded, losses, mom,
                     pass_attempts, passes_made, position, rating, red_cards, saves,
                     shots, tackle_attempts, tackles_made, wins, vproattr, pro_pos)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    match_id, club_id, player_id,
                    player_data.get('playername', ''),
                    player_data.get('goals', 0),
                    player_data.get('assists', 0),
                    player_data.get('cleansheetsdef', 0),
                    player_data.get('cleansheetsgk', 0),
                    player_data.get('goalsconceded', 0),
                    player_data.get('losses', 0),
                    player_data.get('mom', 0),
                    player_data.get('passattempts', 0),
                    player_data.get('passesmade', 0),
                    player_data.get('position', ''),
                    player_data.get('rating', 0),
                    player_data.get('redcards', 0),
                    player_data.get('saves', 0),
                    player_data.get('shots', 0),
                    player_data.get('tackleattempts', 0),
                    player_data.get('tacklesmade', 0),
                    player_data.get('wins', 0),
                    player_data.get('vproattr', ''),
                    player_data.get('pos', '')
                ))
            
            # 4. Insert aggregate data
            agg_data = club_data.get('aggregate', {})
            cursor.execute("""
                INSERT OR IGNORE INTO match_aggregates
                (match_id, club_id, assists, cleansheetsany, cleansheetsdef, cleansheetsgk,
                 goals, goalsconceded, losses, mom, namespace, passattempts, passesmade,
                 pos, rating, realtimegame, realtimeidle, redcards, saves, SCORE,
                 shots, tackleattempts, tacklesmade, vproattr, vprohackreason, wins)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id, club_id,
                agg_data.get('assists', 0),
                agg_data.get('cleansheetsany', 0),
                agg_data.get('cleansheetsdef', 0),
                agg_data.get('cleansheetsgk', 0),
                agg_data.get('goals', 0),
                agg_data.get('goalsconceded', 0),
                agg_data.get('losses', 0),
                agg_data.get('mom', 0),
                agg_data.get('namespace', 0),
                agg_data.get('passattempts', 0),
                agg_data.get('passesmade', 0),
                agg_data.get('pos', 0),
                agg_data.get('rating', 0),
                agg_data.get('realtimegame', 0),
                agg_data.get('realtimeidle', 0),
                agg_data.get('redcards', 0),
                agg_data.get('saves', 0),
                agg_data.get('SCORE', 0),
                agg_data.get('shots', 0),
                agg_data.get('tackleattempts', 0),
                agg_data.get('tacklesmade', 0),
                agg_data.get('vproattr', 0),
                agg_data.get('vprohackreason', 0),
                agg_data.get('wins', 0)
            ))
        
        conn.commit()
        return True
        
    except Exception as e:
        conn.rollback()
        print(f"    ⚠️ Error inserting match {match_id}: {e}")
        return False

async def main():
    """Main function to fetch and store matches from multiple endpoints"""
    print("="*50)
    print("PRO CLUBS MATCH DATA FETCHER (Zendriver)")
    print("="*50)
    
    conn = connect_db()
    
    total_new_matches = 0
    total_existing_matches = 0
    all_matches_count = 0
    
    # Start Zendriver browser with CI-friendly options
    print("\n🌐 Starting browser...")
    browser = await zd.start(
        headless=True,
        sandbox=False,  # Required for GitHub Actions and other CI environments (running as root)
        browser_args=[
            '--disable-dev-shm-usage',  # Overcome limited resource problems
            '--disable-gpu',  # Not needed in headless
            '--no-first-run',
            '--no-default-browser-check',
            '--disable-software-rasterizer'
        ]
    )
    
    try:
        # Fetch from each endpoint
        for endpoint in ENDPOINTS:
            print(f"\n📡 Fetching {endpoint['name']}...")
            matches = await fetch_matches_from_api(endpoint['name'], endpoint['url'], browser)
            
            if not matches:
                print(f"  ❌ No data fetched for {endpoint['name']}")
                continue
            
            all_matches_count += len(matches)
            new_matches = 0
            existing_matches = 0
            
            print(f"  📝 Processing {len(matches)} matches...")
            for match in matches:
                if insert_match_data(conn, match):
                    new_matches += 1
                    print(f"    ✅ Match {match['matchId']} added")
                else:
                    existing_matches += 1
                    print(f"    ⏭️ Match {match['matchId']} already exists")
            
            total_new_matches += new_matches
            total_existing_matches += existing_matches
            
            print(f"  📊 {endpoint['name']} Summary: {new_matches} new, {existing_matches} existing")
    
    finally:
        # Clean up browser
        print("\n🧹 Closing browser...")
        await browser.stop()
    
    # Log the fetch
    cursor = conn.cursor()
    cursor.execute("""
        INSERT INTO fetch_history (matches_found, new_matches_added, status)
        VALUES (?, ?, ?)
    """, (all_matches_count, total_new_matches, 'success'))
    conn.commit()
    
    # Final summary
    print("\n" + "="*50)
    print("SUMMARY")
    print("="*50)
    print(f"Total matches processed: {all_matches_count}")
    print(f"New matches added: {total_new_matches}")
    print(f"Existing matches skipped: {total_existing_matches}")
    print("="*50)
    
    conn.close()

if __name__ == "__main__":
    asyncio.run(main())
