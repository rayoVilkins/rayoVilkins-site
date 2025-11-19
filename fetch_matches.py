import asyncio
import json
import sqlite3
from datetime import datetime
import os

# Import the lightweight HTTP client
import httpx

# Configuration
# Read the database path from environment variable, default to 'build/proclubs.db'
DB_PATH = os.environ.get('DB_PATH', 'build/proclubs.db')
YOUR_CLUB_ID = '19798'

# Multiple endpoints for different match types
ENDPOINTS = [
    {
        'name': 'League Matches',
        # The URL remains the same
        'url': 'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds=19798&matchType=leagueMatch&maxResultCount=10'
    },
    {
        'name': 'Playoff Matches', 
        'url': 'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds=19798&matchType=playoffMatch&maxResultCount=10'
    }
]

# Note: We now use a synchronous function since httpx can handle the network call directly.
def fetch_matches_from_api(endpoint_name, url):
    """Fetch matches from EA API using the httpx HTTP client."""
    
    print(f"  Fetching {endpoint_name}...")
    
    try:
        # We are increasing the timeout value to 30 seconds to allow for slow server responses.
        response = httpx.get(url, timeout=30)
        
        # Raise an exception for bad status codes (4xx or 5xx)
        response.raise_for_status() 
        
        # The EA API returns JSON wrapped in an array, e.g., [{"matches": [...]}]
        data = response.json()

        if not data or not isinstance(data, list) or 'matches' not in data[0]:
            print(f"  ⚠️ Warning: API response structure unexpected for {endpoint_name}.")
            return []

        return data[0]['matches']

    except httpx.HTTPStatusError as e:
        print(f"  ❌ Error fetching {endpoint_name} - HTTP Status Error: {e.response.status_code}")
        return []
    except httpx.RequestError as e:
        # This catches the 'The read operation timed out' error
        print(f"  ❌ Error fetching {endpoint_name} - Network/Request Error: {e}")
        return []
    except Exception as e:
        print(f"  ❌ Error processing response for {endpoint_name}: {e}")
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
    # (The rest of this function remains the same as it handles DB logic)
    match_id = str(match_data['matchId'])
    club_id = YOUR_CLUB_ID
    
    cursor = conn.cursor()
    
    # Check if match already exists
    cursor.execute("SELECT match_id FROM matches WHERE match_id = ?", (match_id,))
    if cursor.fetchone():
        return False # Match already exists

    # Determine which club is ours and which is the opponent
    # NOTE: Assuming 'clubs' array always has 2 entries and one matches YOUR_CLUB_ID
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

def main():
    """Main function to orchestrate the match fetching process."""
    
    print("="*50)
    print("PRO CLUBS MATCH DATA FETCHER (httpx)")
    print("="*50)
    
    # 1. Initialize DB
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = init_db(DB_PATH)
    
    all_matches_count = 0
    total_new_matches = 0
    total_existing_matches = 0

    try:
        
        # 2. Fetch from all endpoints
        for endpoint in ENDPOINTS:
            print("\n" + "-"*30)
            print(f"Fetching from {endpoint['name']}...")
            
            # NOTE: Calling the synchronous fetch function directly
            matches = fetch_matches_from_api(
                endpoint['name'], 
                endpoint['url']
            )
            
            if not matches:
                print(f"  No matches found for {endpoint['name']} or error occurred.")
                continue

            all_matches_count += len(matches)
            new_matches = 0
            existing_matches = 0
            
            print(f"  📝 Processing {len(matches)} matches...")
            for match in matches:
                # We can now print match IDs without worrying about log limits since we aren't using Zendriver's verbose output.
                if insert_match_data(conn, match):
                    new_matches += 1
                    # print(f"    ✅ Match {match['matchId']} added") 
                else:
                    existing_matches += 1
                    # print(f"    ⏭️ Match {match['matchId']} already exists") 
            
            total_new_matches += new_matches
            total_existing_matches += existing_matches
            
            print(f"  📊 {endpoint['name']} Summary: {new_matches} new, {existing_matches} existing")
    
    except Exception as e:
        # Log the failed fetch
        try:
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO fetch_history (matches_found, new_matches_added, status)
                VALUES (?, ?, ?)
            """, (all_matches_count, total_new_matches, 'failure'))
            conn.commit()
        except Exception as db_e:
            print(f"  ❌ Error logging failure to DB: {db_e}")
        
        print(f"\nFATAL ERROR in main execution loop: {e}")
        # Reraise the original error to fail the workflow
        raise 
    
    finally:
        # No browser cleanup needed! This code is much cleaner.
        pass
    
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
    try:
        # No need for asyncio.run() anymore!
        main()
    except Exception as e:
        # Catch any unexpected top-level exceptions
        print(f"\n--- TOP LEVEL EXECUTION ERROR ---")
        print(f"An unhandled exception occurred: {e}")
        # Reraise to ensure the GitHub Action fails
        raise
