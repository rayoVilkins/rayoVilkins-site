import asyncio
import json
import sqlite3
from datetime import datetime
import os

import zendriver as zd

# Configuration
# Read the database path from environment variable, default to 'build/proclubs.db'
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
        content = await page.content()
        
        # The EA API returns JSON wrapped in an array, e.g., [{"matches": [...]}]
        # We expect the content to be a JSON string
        try:
            # We assume the API returns a JSON array of club objects, each containing a 'matches' key
            data = json.loads(content)
        except json.JSONDecodeError:
            print(f"  ❌ Error: Failed to decode JSON content for {endpoint_name}. Raw content start: {content[:100]}")
            return []

        if not data or not isinstance(data, list) or 'matches' not in data[0]:
            print(f"  ⚠️ Warning: API response structure unexpected for {endpoint_name}.")
            return []

        return data[0]['matches']

    except Exception as e:
        print(f"  ❌ Error fetching {endpoint_name}: {e}")
        return []

def init_db(db_path):
    """Initialize the SQLite database and tables."""
    print(f"🗃️ Initializing database at {db_path}...")
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Matches Table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS matches (
            match_id TEXT PRIMARY KEY,
            match_date TEXT NOT NULL,
            match_type TEXT NOT NULL,
            club_id TEXT NOT NULL,
            club_data TEXT NOT NULL,
            opponent_id TEXT NOT NULL,
            opponent_data TEXT NOT NULL,
            aggregated_data TEXT NOT NULL
        )
    """)
    
    # Fetch History Table (for logging runs)
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS fetch_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            matches_found INTEGER,
            new_matches_added INTEGER,
            status TEXT
        )
    """)
    
    conn.commit()
    print("   Database initialized.")
    return conn

def insert_match_data(conn, match_data):
    """Inserts match data if it doesn't already exist. Returns True if new, False if existing."""
    match_id = str(match_data['matchId'])
    club_id = YOUR_CLUB_ID
    
    cursor = conn.cursor()
    
    # Check if match already exists
    cursor.execute("SELECT match_id FROM matches WHERE match_id = ?", (match_id,))
    if cursor.fetchone():
        return False # Match already exists

    # Determine which club is ours and which is the opponent
    if match_data['clubs'][0]['clubId'] == club_id:
        our_club_data = match_data['clubs'][0]
        opponent_club_data = match_data['clubs'][1]
    else:
        our_club_data = match_data['clubs'][1]
        opponent_club_data = match_data['clubs'][0]

    # Prepare data for insertion
    match_date = datetime.fromtimestamp(match_data['timestamp'] / 1000).isoformat()
    match_type = match_data['matchType']
    opponent_id = opponent_club_data['clubId']
    
    # Store club data and opponent data as JSON strings
    our_club_data_json = json.dumps(our_club_data)
    opponent_club_data_json = json.dumps(opponent_club_data)
    
    # Store the entire match object for later aggregation/processing
    aggregated_data_json = json.dumps(match_data)
    
    try:
        cursor.execute("""
            INSERT INTO matches (match_id, match_date, match_type, club_id, club_data, opponent_id, opponent_data, aggregated_data)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """, (match_id, match_date, match_type, club_id, our_club_data_json, opponent_id, opponent_club_data_json, aggregated_data_json))
        conn.commit()
        return True
    except sqlite3.IntegrityError:
        # Fallback for unexpected duplicate (should be caught by the SELECT)
        return False
    except Exception as e:
        print(f"  ❌ Error inserting match {match_id}: {e}")
        return False

async def main():
    """Main function to orchestrate the match fetching process."""
    
    print("="*50)
    print("PRO CLUBS MATCH DATA FETCHER (Zendriver)")
    print("="*50)
    
    # 1. Initialize DB
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = init_db(DB_PATH)
    
    browser = None
    all_matches_count = 0
    total_new_matches = 0
    total_existing_matches = 0

    try:
        # Start Zendriver browser with CI-friendly options
        print("\n🌐 Starting browser...")
        # CRITICAL: Use the known executable path and aggressive CI flags
        browser = await zd.start(
            # Using headless=True is the older way; keeping the new way in args is better
            headless=True, # Keeping this here for compatibility, but the args are more important
            no_sandbox=True, # Critical flag
            browser_executable_path="/usr/bin/google-chrome",
            timeout=30, # Increased timeout to 30 seconds for browser startup
            browser_args=[
                # Recommended fixes for CI/Docker environments (Ensure these are present):
                '--headless=new',                # Use the new, more reliable headless mode
                '--no-sandbox',                  # Necessary in most containerized environments
                '--disable-setuid-sandbox',      # Another critical sandbox bypass
                '--disable-dev-shm-usage',       # Fixes resource limitations on GHA runners (CRITICAL FIX)
                '--remote-debugging-port=9222',  # Explicitly opens a port for connection
                '--disable-site-isolation-trials', # Added for extra robustness in CI

                # Other robustness flags
                '--disable-gpu',
                '--no-first-run',
                '--no-default-browser-check',
                '--disable-software-rasterizer',
                '--single-process',             # Added this as another strong fix for CI stability
            ]
        )
        print("✅ Browser started successfully.")
        
        # 2. Fetch from all endpoints
        for endpoint in ENDPOINTS:
            print("\n" + "-"*30)
            print(f"Fetching from {endpoint['name']}...")
            
            matches = await fetch_matches_from_api(
                endpoint['name'], 
                endpoint['url'], 
                browser
            )
            
            if not matches:
                print(f"  No matches found for {endpoint['name']} or error occurred.")
                continue

            all_matches_count += len(matches)
            new_matches = 0
            existing_matches = 0
            
            print(f"  📝 Processing {len(matches)} matches...")
            for match in matches:
                if insert_match_data(conn, match):
                    new_matches += 1
                    # print(f"    ✅ Match {match['matchId']} added") # Suppress detailed print for brevity in GHA logs
                else:
                    existing_matches += 1
                    # print(f"    ⏭️ Match {match['matchId']} already exists") # Suppress detailed print
            
            total_new_matches += new_matches
            total_existing_matches += existing_matches
            
            print(f"  📊 {endpoint['name']} Summary: {new_matches} new, {existing_matches} existing")
    
    except Exception as e:
        print(f"\nFATAL ERROR in main execution loop: {e}")
        # Log the failed fetch
        cursor = conn.cursor()
        # FIX: Ensure this block runs even if the browser startup fails and 'browser' is None
        try:
            cursor.execute("""
                INSERT INTO fetch_history (matches_found, new_matches_added, status)
                VALUES (?, ?, ?)
            """, (all_matches_count, total_new_matches, 'failure'))
            conn.commit()
        except Exception as db_e:
            print(f"  ❌ Error logging failure to DB: {db_e}")
        # Reraise the original error to fail the workflow
        raise 
    
    finally:
        # Clean up browser
        if browser:
            print("\n🧹 Closing browser...")
            try:
                await browser.stop()
                print("   Browser closed.")
            except Exception as e:
                print(f"   ⚠️ Warning: Failed to cleanly close browser: {e}")
    
    # Final summary (only if connection was successful)
    if all_matches_count > 0:
        cursor = conn.cursor()
        # Log the successful run
        cursor.execute("""
            INSERT INTO fetch_history (matches_found, new_matches_added, status)
            VALUES (?, ?, ?)
        """, (all_matches_count, total_new_matches, 'success'))
        conn.commit()

        print("\n" + "="*50)
        print("SUMMARY")
        print("="*50)
        print(f"Total matches processed: {all_matches_count}")
        print(f"New matches added: {total_new_matches}")
        print(f"Existing matches skipped: {total_existing_matches}")
        print(f"Database Path: {DB_PATH}")
        print("="*50)

if __name__ == '__main__':
    # Ensure all file systems are ready before running the async main
    try:
        asyncio.run(main())
    except Exception as e:
        # Catch any unexpected top-level exceptions
        print(f"\n--- TOP LEVEL EXECUTION ERROR ---")
        print(f"An unhandled exception occurred: {e}")
        # We don't need to re-raise here because the `main`'s error handling already did it.
        # But we keep this for ultimate safety.
        # Reraise to ensure the GitHub Action fails
        raise
