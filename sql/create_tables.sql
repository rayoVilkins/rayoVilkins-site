-- Main matches table
CREATE TABLE IF NOT EXISTS matches (
    match_id TEXT PRIMARY KEY,
    match_timestamp INTEGER NOT NULL,
    match_date DATETIME,
    time_ago_number INTEGER,
    time_ago_unit TEXT,
    -- Raw JSON for complete preservation
    raw_json JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Match clubs table with unique constraint
CREATE TABLE IF NOT EXISTS match_clubs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    match_id TEXT NOT NULL,
    club_id TEXT NOT NULL,
    club_name TEXT,
    date TEXT,
    game_number TEXT,
    goals INTEGER,
    goals_against INTEGER,
    losses INTEGER,
    match_type INTEGER,
    result INTEGER,  -- 1=win, 2=loss, 4=draw, 16385=win by DNF
    score INTEGER,
    season_id TEXT,
    team_id TEXT,
    ties INTEGER,
    winner_by_dnf INTEGER,
    wins INTEGER,
    -- Club details
    region_id TEXT,
    -- Custom kit data
    stad_name TEXT,
    kit_id TEXT,
    crest_asset_id TEXT,
    -- Store full customKit JSON for all the color codes
    custom_kit_json JSON,
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    UNIQUE(match_id, club_id)  -- Prevents duplicate club entries per match
);

-- Match players table with unique constraint
CREATE TABLE IF NOT EXISTS match_players (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    match_id TEXT NOT NULL,
    club_id TEXT NOT NULL,
    player_id TEXT NOT NULL,
    player_name TEXT,
    -- Stats
    assists INTEGER,
    cleansheetsany INTEGER,
    cleansheetsdef INTEGER,
    cleansheetsgk INTEGER,
    goals INTEGER,
    goalsconceded INTEGER,
    losses INTEGER,
    mom INTEGER,  -- Man of the Match
    namespace INTEGER,
    passattempts INTEGER,
    passesmade INTEGER,
    pos TEXT,  -- Position
    rating REAL,
    realtimegame INTEGER,
    realtimeidle INTEGER,
    redcards INTEGER,
    saves INTEGER,
    score INTEGER,
    shots INTEGER,
    tackleattempts INTEGER,
    tacklesmade INTEGER,
    wins INTEGER,
    -- Pro attributes
    vproattr TEXT,  -- The attribute string
    vprohackreason TEXT,
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    UNIQUE(match_id, player_id)  -- Prevents duplicate player entries per match
);

-- Match aggregates table with unique constraint
CREATE TABLE IF NOT EXISTS match_aggregates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    match_id TEXT NOT NULL,
    club_id TEXT NOT NULL,
    assists INTEGER,
    cleansheetsany INTEGER,
    cleansheetsdef INTEGER,
    cleansheetsgk INTEGER,
    goals INTEGER,
    goalsconceded INTEGER,
    losses INTEGER,
    mom INTEGER,
    namespace INTEGER,
    passattempts INTEGER,
    passesmade INTEGER,
    pos INTEGER,
    rating REAL,
    realtimegame INTEGER,
    realtimeidle INTEGER,
    redcards INTEGER,
    saves INTEGER,
    score INTEGER,
    shots INTEGER,
    tackleattempts INTEGER,
    tacklesmade INTEGER,
    vproattr INTEGER,
    vprohackreason INTEGER,
    wins INTEGER,
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    UNIQUE(match_id, club_id)  -- Prevents duplicate aggregate entries per match
);

-- Clubs reference table
CREATE TABLE IF NOT EXISTS clubs (
    club_id TEXT PRIMARY KEY,
    club_name TEXT,
    region_id TEXT,
    team_id TEXT,
    stad_name TEXT,
    crest_asset_id TEXT,
    last_seen TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Players reference table
CREATE TABLE IF NOT EXISTS players (
    player_id TEXT PRIMARY KEY,
    player_name TEXT,
    last_position TEXT,
    last_club_id TEXT,
    last_seen TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fetch history tracking
CREATE TABLE IF NOT EXISTS fetch_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fetch_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    matches_found INTEGER,
    new_matches_added INTEGER,
    oldest_match_timestamp INTEGER,
    newest_match_timestamp INTEGER,
    raw_response JSON,
    status TEXT,
    error_message TEXT
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_match_timestamp ON matches(match_timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_club_matches ON match_clubs(club_id, match_id);
CREATE INDEX IF NOT EXISTS idx_player_matches ON match_players(player_id, match_id);
CREATE INDEX IF NOT EXISTS idx_player_stats ON match_players(goals DESC, assists DESC, rating DESC);
