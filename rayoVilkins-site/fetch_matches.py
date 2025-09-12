import requests
import json
import sqlite3
from datetime import datetime
import time

import os
# Configuration
DB_PATH = os.environ.get('DB_PATH', 'build/proclubs.db')
YOUR_CLUB_ID = '63719'

# Multiple endpoints for different match types
ENDPOINTS = [
    {
        'name': 'League Matches',
        'url': 'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds=63719&matchType=leagueMatch&maxResultCount=10'
    },
    {
        'name': 'Playoff Matches', 
        'url': 'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds=63719&matchType=playoffMatch&maxResultCount=10'
    }
]

def fetch_matches_from_api(endpoint_name, url):
    """Fetch matches from EA API with proper headers"""
    
    headers = {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'application/json',
        'Accept-Language': 'en-US,en;q=0.9',
        'Accept-Encoding': 'gzip, deflate, br',
        'Origin': 'https://www.ea.com',
        'Referer': 'https://www.ea.com/',
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache'
    }
    
    for attempt in range(3):
        try:
            print(f"  Fetching {endpoint_name} (attempt {attempt + 1}/3)...")
            timeout = 30 + (attempt * 10)
            
            response = requests.get(url, headers=headers, timeout=timeout)
            response.raise_for_status()
            data = response.json()
            print(f"  ✓ Successfully fetched {len(data)} {endpoint_name}")
            return data
            
        except requests.exceptions.Timeout:
            print(f"    Timeout after {timeout} seconds, retrying...")
            time.sleep(2)
            continue
            
        except requests.exceptions.RequestException as e:
            print(f"    Error on attempt {attempt + 1}: {e}")
            if attempt < 2:
                time.sleep(2)
                continue
            else:
                print(f"  ✗ Failed to fetch {endpoint_name}")
                return None
    
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
    """Insert a single match and all related data"""
    match_id = match['matchId']
    
    if match_exists(conn, match_id):
        return False
    
    cursor = conn.cursor()
    
    try:
        # 1. Insert into matches table
        cursor.execute("""
            INSERT INTO matches (match_id, match_timestamp, time_ago_number, time_ago_unit, raw_json)
            VALUES (?, ?, ?, ?, ?)
        """, (
            match_id,
            match['timestamp'],
            match['timeAgo'].get('number'),
            match['timeAgo'].get('unit'),
            json.dumps(match)
        ))
        
        # 2. Process each club in the match
        for club_id, club_data in match['clubs'].items():
            cursor.execute("""
                INSERT INTO match_clubs (
                    match_id, club_id, club_name, date, game_number, goals, goals_against,
                    losses, match_type, result, score, season_id, team_id, ties, 
                    winner_by_dnf, wins, region_id, stad_name, kit_id, crest_asset_id, custom_kit_json
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                match_id, club_id,
                club_data['details']['name'],
                club_data.get('date'),
                club_data.get('gameNumber'),
                int(club_data.get('goals', 0)),
                int(club_data.get('goalsAgainst', 0)),
                int(club_data.get('losses', 0)),
                int(club_data.get('matchType', 0)),
                int(club_data.get('result', 0)),
                int(club_data.get('score', 0)),
                club_data.get('season_id'),
                club_data.get('TEAM'),
                int(club_data.get('ties', 0)),
                int(club_data.get('winnerByDnf', 0)),
                int(club_data.get('wins', 0)),
                club_data['details'].get('regionId'),
                club_data['details']['customKit'].get('stadName'),
                club_data['details']['customKit'].get('kitId'),
                club_data['details']['customKit'].get('crestAssetId'),
                json.dumps(club_data['details']['customKit'])
            ))
            
            cursor.execute("""
                INSERT OR REPLACE INTO clubs (club_id, club_name, region_id, team_id, stad_name, crest_asset_id, last_seen)
                VALUES (?, ?, ?, ?, ?, ?, datetime('now'))
            """, (
                club_id,
                club_data['details']['name'],
                club_data['details'].get('regionId'),
                club_data['details'].get('teamId'),
                club_data['details']['customKit'].get('stadName'),
                club_data['details']['customKit'].get('crestAssetId')
            ))
        
        # 3. Process players
        for club_id, players in match.get('players', {}).items():
            for player_id, player_data in players.items():
                cursor.execute("""
                    INSERT INTO match_players (
                        match_id, club_id, player_id, player_name, assists, cleansheetsany, 
                        cleansheetsdef, cleansheetsgk, goals, goalsconceded, losses, mom,
                        namespace, passattempts, passesmade, pos, rating, realtimegame,
                        realtimeidle, redcards, saves, score, shots, tackleattempts,
                        tacklesmade, wins, vproattr, vprohackreason
                    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """, (
                    match_id, club_id, player_id,
                    player_data.get('playername'),
                    int(player_data.get('assists', 0)),
                    int(player_data.get('cleansheetsany', 0)),
                    int(player_data.get('cleansheetsdef', 0)),
                    int(player_data.get('cleansheetsgk', 0)),
                    int(player_data.get('goals', 0)),
                    int(player_data.get('goalsconceded', 0)),
                    int(player_data.get('losses', 0)),
                    int(player_data.get('mom', 0)),
                    int(player_data.get('namespace', 0)),
                    int(player_data.get('passattempts', 0)),
                    int(player_data.get('passesmade', 0)),
                    player_data.get('pos'),
                    float(player_data.get('rating', 0)),
                    int(player_data.get('realtimegame', 0)),
                    int(player_data.get('realtimeidle', 0)),
                    int(player_data.get('redcards', 0)),
                    int(player_data.get('saves', 0)),
                    int(player_data.get('SCORE', 0)),
                    int(player_data.get('shots', 0)),
                    int(player_data.get('tackleattempts', 0)),
                    int(player_data.get('tacklesmade', 0)),
                    int(player_data.get('wins', 0)),
                    player_data.get('vproattr'),
                    player_data.get('vprohackreason')
                ))
                
                cursor.execute("""
                    INSERT OR REPLACE INTO players (player_id, player_name, last_position, last_club_id, last_seen)
                    VALUES (?, ?, ?, ?, datetime('now'))
                """, (
                    player_id,
                    player_data.get('playername'),
                    player_data.get('pos'),
                    club_id
                ))
        
        # 4. Process aggregates
        for club_id, agg_data in match.get('aggregate', {}).items():
            cursor.execute("""
                INSERT INTO match_aggregates (
                    match_id, club_id, assists, cleansheetsany, cleansheetsdef, cleansheetsgk,
                    goals, goalsconceded, losses, mom, namespace, passattempts, passesmade,
                    pos, rating, realtimegame, realtimeidle, redcards, saves, score, shots,
                    tackleattempts, tacklesmade, vproattr, vprohackreason, wins
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
        print(f"    Error inserting match {match_id}: {e}")
        return False

def main():
    """Main function to fetch and store matches from multiple endpoints"""
    print("="*50)
    print("PRO CLUBS MATCH DATA FETCHER")
    print("="*50)
    
    conn = connect_db()
    
    total_new_matches = 0
    total_existing_matches = 0
    all_matches_count = 0
    
    # Fetch from each endpoint
    for endpoint in ENDPOINTS:
        print(f"\nFetching {endpoint['name']}...")
        matches = fetch_matches_from_api(endpoint['name'], endpoint['url'])
        
        if not matches:
            print(f"  No data fetched for {endpoint['name']}")
            continue
        
        all_matches_count += len(matches)
        new_matches = 0
        existing_matches = 0
        
        print(f"  Processing {len(matches)} matches...")
        for match in matches:
            if insert_match_data(conn, match):
                new_matches += 1
                print(f"    ✓ Match {match['matchId']} added")
            else:
                existing_matches += 1
                print(f"    - Match {match['matchId']} already exists")
        
        total_new_matches += new_matches
        total_existing_matches += existing_matches
        
        print(f"  {endpoint['name']} Summary: {new_matches} new, {existing_matches} existing")
    
    # Log the fetch
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
    conn.close()
    
    print("\n" + "="*50)
    print("OVERALL SUMMARY:")
    print(f"  Total matches found: {all_matches_count}")
    print(f"  New matches added: {total_new_matches}")
    print(f"  Existing matches skipped: {total_existing_matches}")
    print("="*50)
    
    # Update log file
    with open('fetch_log.txt', 'a') as f:
        f.write(f"\n{datetime.now()} - Found: {all_matches_count}, Added: {total_new_matches}, Skipped: {total_existing_matches} ")

if __name__ == "__main__":
    main()