import json
import sqlite3
from datetime import datetime
import time
import os
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# Configuration
DB_PATH = os.environ.get('DB_PATH', 'build/proclubs.db')
YOUR_CLUB_ID = '19798'

# Multiple endpoints for different match types
ENDPOINTS = [
    {
        'name': 'League Matches',
        'url': f'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds={YOUR_CLUB_ID}&matchType=leagueMatch&maxResultCount=10'
    },
    {
        'name': 'Playoff Matches', 
        'url': f'https://proclubs.ea.com/api/fc/clubs/matches?platform=common-gen5&clubIds={YOUR_CLUB_ID}&matchType=playoffMatch&maxResultCount=10'
    }
]

def create_driver():
    """Create a Selenium WebDriver with Chrome"""
    chrome_options = Options()
    chrome_options.add_argument('--headless')  # Run in background
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-blink-features=AutomationControlled')
    chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
    chrome_options.add_experimental_option('useAutomationExtension', False)
    
    # Disable webdriver detection
    chrome_options.add_argument('--disable-blink-features=AutomationControlled')
    
    # User agent
    chrome_options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36')
    
    driver = webdriver.Chrome(options=chrome_options)
    
    # Remove webdriver property
    driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
    
    return driver

def fetch_matches_from_api_selenium(endpoint_name, url, driver):
    """Fetch matches from EA API using Selenium"""
    
    for attempt in range(3):
        try:
            print(f"  Fetching {endpoint_name} (attempt {attempt + 1}/3)...")
            
            # Add delay between attempts
            if attempt > 0:
                delay = 5 + (attempt * 2)
                print(f"    Waiting {delay} seconds before retry...")
                time.sleep(delay)
            else:
                time.sleep(2)
            
            # Navigate to URL
            driver.get(url)
            
            # Wait for page to load (up to 30 seconds)
            time.sleep(3)
            
            # Get page source
            page_source = driver.page_source
            
            # Check if we got JSON response or HTML error page
            if '<html' in page_source.lower() or '403' in page_source:
                print(f"    Received HTML error page instead of JSON")
                if attempt < 2:
                    continue
                else:
                    print(f"  ✗ Failed to fetch {endpoint_name} - Access Forbidden")
                    return None
            
            # Try to parse as JSON
            # The JSON is usually in a <pre> tag or directly in body
            try:
                # Try to find pre tag first
                pre_element = driver.find_element(By.TAG_NAME, "pre")
                json_text = pre_element.text
            except:
                # If no pre tag, use body
                json_text = driver.find_element(By.TAG_NAME, "body").text
            
            data = json.loads(json_text)
            print(f"  ✓ Successfully fetched {len(data)} {endpoint_name}")
            return data
            
        except json.JSONDecodeError as e:
            print(f"    Failed to parse JSON on attempt {attempt + 1}: {e}")
            if attempt < 2:
                continue
            else:
                print(f"  ✗ Failed to fetch {endpoint_name}")
                return None
                
        except Exception as e:
            print(f"    Error on attempt {attempt + 1}: {e}")
            if attempt < 2:
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
    """Insert a single match and all related data using INSERT OR IGNORE"""
    match_id = match['matchId']
    
    if match_exists(conn, match_id):
        return False
    
    cursor = conn.cursor()
    
    try:
        # 1. Insert into matches table (PRIMARY KEY prevents duplicates)
        cursor.execute("""
            INSERT OR IGNORE INTO matches (match_id, match_timestamp, time_ago_number, time_ago_unit, raw_json)
            VALUES (?, ?, ?, ?, ?)
        """, (
            match_id,
            match['timestamp'],
            match['timeAgo'].get('number'),
            match['timeAgo'].get('unit'),
            json.dumps(match)
        ))
        
        # Check if match was actually inserted
        if cursor.rowcount == 0:
            return False
        
        # 2. Process each club in the match
        for club_id, club_data in match['clubs'].items():
            cursor.execute("""
                INSERT OR IGNORE INTO match_clubs (
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
            
            # Update clubs table
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
                    INSERT OR IGNORE INTO match_players (
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
                
                # Update players table
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
                INSERT OR IGNORE INTO match_aggregates (
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
        print(f"    ⚠️ Error inserting match {match_id}: {e}")
        return False

def main():
    """Main function to fetch and store matches from multiple endpoints"""
    print("="*50)
    print("PRO CLUBS MATCH DATA FETCHER (SELENIUM)")
    print("="*50)
    print(f"Club ID: {YOUR_CLUB_ID}")
    print("="*50)
    
    # Create Selenium driver
    print("\n🌐 Initializing browser...")
    try:
        driver = create_driver()
        print("  ✓ Browser initialized")
    except Exception as e:
        print(f"  ✗ Failed to initialize browser: {e}")
        print("\n⚠️ Make sure Chrome and ChromeDriver are installed!")
        return
    
    conn = connect_db()
    
    total_new_matches = 0
    total_existing_matches = 0
    all_matches_count = 0
    
    try:
        # Fetch from each endpoint
        for endpoint in ENDPOINTS:
            print(f"\n📡 Fetching {endpoint['name']}...")
            matches = fetch_matches_from_api_selenium(endpoint['name'], endpoint['url'], driver)
            
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
        # Always close the browser
        print("\n🔒 Closing browser...")
        driver.quit()
    
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
    
    # Get total matches in database
    cursor.execute("SELECT COUNT(*) as count FROM matches")
    total_in_db = cursor.fetchone()['count']
    
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
