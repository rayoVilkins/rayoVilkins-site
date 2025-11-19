import asyncio
import json
import sqlite3
from datetime import datetime
import os
import sys
from shutil import which

import zendriver as zd

# Configuration
DB_PATH = os.environ.get('DB_PATH', 'build/proclubs.db')
YOUR_CLUB_ID = '19798'

# Multiple endpoints for different match types
ENDPOINTS = [
    {
        'name': 'League Matches',
        'url': f'https://proclubs.ea.com/api/nhl/clubs/matches?clubIds={YOUR_CLUB_ID}&matchType=league'
    },
    {
        'name': 'Cup Matches',
        'url': f'https://proclubs.ea.com/api/nhl/clubs/matches?clubIds={YOUR_CLUB_ID}&matchType=cup'
    },
    {
        'name': 'Drop-in Matches',
        'url': f'https://proclubs.ea.com/api/nhl/clubs/matches?clubIds={YOUR_CLUB_ID}&matchType=dropin'
    }
]

# Database helper functions
def connect_db():
    """Create and return a connection to the SQLite database."""
    conn = sqlite3.connect(DB_PATH)
    conn.execute('PRAGMA foreign_keys = ON')
    return conn

def create_tables(conn):
    """Create tables if they don't exist."""
    cursor = conn.cursor()
    
    # Clubs table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS clubs (
            club_id TEXT PRIMARY KEY,
            club_name TEXT NOT NULL,
            region_id TEXT,
            team_id INTEGER,
            crest_asset_id INTEGER,
            last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    # Matches table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS matches (
            match_id TEXT PRIMARY KEY,
            match_time TIMESTAMP,
            match_type TEXT,
            is_home INTEGER,
            our_club_id TEXT,
            opp_club_id TEXT,
            our_score INTEGER,
            opp_score INTEGER,
            result TEXT,
            venue TEXT,
            FOREIGN KEY (our_club_id) REFERENCES clubs(club_id),
            FOREIGN KEY (opp_club_id) REFERENCES clubs(club_id)
        )
    """)
    
    # Player stats table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS player_stats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            match_id TEXT,
            club_id TEXT,
            player_name TEXT,
            position TEXT,
            rating REAL,
            goals INTEGER,
            assists INTEGER,
            shots INTEGER,
            passes INTEGER,
            tackles INTEGER,
            interceptions INTEGER,
            saves INTEGER,
            clean_sheet INTEGER,
            FOREIGN KEY (match_id) REFERENCES matches(match_id),
            FOREIGN KEY (club_id) REFERENCES clubs(club_id)
        )
    """)
    
    conn.commit()

def match_exists(conn, match_id):
    """Check if a match already exists in the database."""
    cursor = conn.cursor()
    cursor.execute("SELECT 1 FROM matches WHERE match_id = ?", (match_id,))
    return cursor.fetchone() is not None

def insert_club(conn, club_data, is_our_club=True):
    """Insert or update club data."""
    cursor = conn.cursor()
    club_id = str(club_data.get('clubId'))
    
    if not club_id:
        return None

    club_name = club_data.get('name', '')
    region_id = club_data.get('regionId', '')
    team_id = club_data.get('teamId')
    crest_asset_id = club_data.get('crestAssetId')

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
        club_name,
        region_id,
        team_id,
        crest_asset_id
    ))
    
    return club_id

def insert_match_data(conn, match_data):
    """Insert a single match and its player stats."""
    cursor = conn.cursor()
    match_id = str(match_data.get('matchId'))

    if not match_id:
        print("⚠️ Skipping match with no matchId")
        return False
    
    if match_exists(conn, match_id):
        print(f"  ↩️ Match {match_id} already exists, skipping")
        return False

    try:
        match_time = datetime.fromtimestamp(match_data.get('timestamp', 0))
        match_type = match_data.get('matchType', 'unknown')
        venue = match_data.get('venue', 'Unknown')

        # Our club data
        our_club_data = match_data.get('ourClub', {})
        our_club_id = insert_club(conn, our_club_data, is_our_club=True)

        # Opponent club data
        opp_club_data = match_data.get('opponentClub', {})
        opp_club_id = insert_club(conn, opp_club_data, is_our_club=False)

        our_score = match_data.get('ourScore', 0)
        opp_score = match_data.get('opponentScore', 0)

        # Determine result
        if our_score > opp_score:
            result = 'W'
        elif our_score < opp_score:
            result = 'L'
        else:
            result = 'D'

        # Insert match
        cursor.execute("""
            INSERT INTO matches (
                match_id, match_time, match_type, is_home,
                our_club_id, opp_club_id, our_score, opp_score,
                result, venue
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            match_id,
            match_time,
            match_type,
            1 if match_data.get('isHome', True) else 0,
            our_club_id,
            opp_club_id,
            our_score,
            opp_score,
            result,
            venue
        ))

        # Insert player stats (our team)
        for player in match_data.get('ourPlayers', []):
            cursor.execute("""
                INSERT INTO player_stats (
                    match_id, club_id, player_name, position, rating,
                    goals, assists, shots, passes, tackles,
                    interceptions, saves, clean_sheet
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id,
                our_club_id,
                player.get('name', ''),
                player.get('position', ''),
                player.get('rating', 0.0),
                player.get('goals', 0),
                player.get('assists', 0),
                player.get('shots', 0),
                player.get('passes', 0),
                player.get('tackles', 0),
                player.get('interceptions', 0),
                player.get('saves', 0),
                player.get('cleanSheet', 0)
            ))

        # Insert player stats (opponent)
        for player in match_data.get('opponentPlayers', []):
            cursor.execute("""
                INSERT INTO player_stats (
                    match_id, club_id, player_name, position, rating,
                    goals, assists, shots, passes, tackles,
                    interceptions, saves, clean_sheet
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id,
                opp_club_id,
                player.get('name', ''),
                player.get('position', ''),
                player.get('rating', 0.0),
                player.get('goals', 0),
                player.get('assists', 0),
                player.get('shots', 0),
                player.get('passes', 0),
                player.get('tackles', 0),
                player.get('interceptions', 0),
                player.get('saves', 0),
                player.get('cleanSheet', 0)
            ))
        
        conn.commit()
        return True
        
    except Exception as e:
        conn.rollback()
        print(f"    ⚠️ Error inserting match {match_id}: {e}")
        return False

async def fetch_matches_from_api(endpoint_name, url, browser):
    """Fetch JSON match data from EA API using Zendriver to avoid bot detection."""
    print(f"    🌐 Navigating to {url}")
    
    tab = await browser.get(url)
    
    # Wait for the JSON response from the network
    try:
        response = await tab.wait_for_response(lambda r: (
            'proclubs.ea.com/api/nhl/clubs/matches' in r.url
            and r.status == 200
        ), timeout=15.0)
    except asyncio.TimeoutError:
        print(f"    ❌ Timeout waiting for API response for {endpoint_name}")
        return []
    
    try:
        data = await response.json()
    except Exception as e:
        print(f"    ❌ Failed to parse JSON for {endpoint_name}: {e}")
        return []
    
    matches = data.get('matches', [])
    
    print(f"    ✅ Received {len(matches)} matches from {endpoint_name}")
    return matches

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

    browser_kwargs = dict(
        headless=True,
        no_sandbox=True,  # Required for GitHub Actions and other CI environments
        browser_args=[
            "--disable-dev-shm-usage",  # Overcome limited resource problems
            "--disable-gpu",            # Not needed in headless
            "--no-first-run",
            "--no-default-browser-check",
            "--disable-software-rasterizer",
        ],
    )

    # On GitHub Actions (Linux), Zendriver sometimes picks the wrong browser.
    # Force the Chrome path explicitly to avoid "Failed to connect to browser".
    if os.getenv("GITHUB_ACTIONS") == "true" and sys.platform.startswith("linux"):
        chrome_path = which("google-chrome") or which("chrome") or which("chromium") or "/usr/bin/google-chrome"
        browser_kwargs["browser_executable_path"] = chrome_path

    browser = await zd.start(**browser_kwargs)
    
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
            
            print(f"  ✅ {endpoint['name']} - New: {new_matches}, Existing: {existing_matches}")
            total_new_matches += new_matches
            total_existing_matches += existing_matches
    
    finally:
        print("\n🧹 Closing browser...")
        await browser.close()
    
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
