PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE matches (
    match_id TEXT PRIMARY KEY,
    match_timestamp INTEGER NOT NULL,
    match_date DATETIME,
    time_ago_number INTEGER,
    time_ago_unit TEXT,
    -- Raw JSON for complete preservation
    raw_json JSON NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO matches VALUES('1934776370243',1758227725,NULL,21,'minutes','{"matchId": "1934776370243", "timestamp": 1758227725, "timeAgo": {"number": 21, "unit": "minutes"}, "clubs": {"19229": {"date": "1758227724", "gameNumber": "0", "goals": "5", "goalsAgainst": "1", "losses": "0", "matchType": "1", "result": "1", "score": "5", "season_id": "0", "TEAM": "21", "ties": "0", "winnerByDnf": "0", "wins": "1", "details": {"name": "Con9sole", "clubId": 19229, "regionId": 4281153, "teamId": 21, "customKit": {"stadName": "Console game", "kitId": "172032", "seasonalTeamId": "0", "seasonalKitId": "0", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160401"}}}, "19798": {"date": "1758227724", "gameNumber": "0", "goals": "1", "goalsAgainst": "5", "losses": "1", "matchType": "1", "result": "2", "score": "1", "season_id": "0", "TEAM": "480", "ties": "0", "winnerByDnf": "0", "wins": "0", "details": {"name": "Rayo Vilkins", "clubId": 19798, "regionId": 5723475, "teamId": 480, "customKit": {"stadName": "Estadio de Vallecas", "kitId": "3932160", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160807"}}}}, "players": {"19798": {"182482543": {"archetypeid": "8", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "1:2,100:2,106:1,111:41,112:1,143:1,152:4,163:2,174:7,175:3,177:2,182:4,183:1,212:1,215:8,216:1,219:2,25:1,26:6,28:2,30:6,31:1,32:2,97:6", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "9", "passesmade": "8", "pos": "defender", "punchSaves": "0", "rating": "6.10", "realtimegame": "904", "realtimeidle": "6", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "3", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "DerBones"}, "212960503": {"archetypeid": "7", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:4,100:1,105:2,106:2,107:1,108:2,109:1,111:29,112:1,121:1,151:1,152:3,163:3,164:1,171:1,174:7,175:7,176:2,177:1,182:2,183:2,184:1,2:1,215:7,216:2,219:1,229:1,24:1,25:2,26:3,28:3,30:6,31:1,33:1,34:1,5:1,6:4,97:5", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "9", "passesmade": "7", "pos": "midfielder", "punchSaves": "0", "rating": "5.80", "realtimegame": "904", "realtimeidle": "4", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "6", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "rv-Doggie"}, "248203001": {"archetypeid": "12", "assists": "1", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "1:10,101:2,107:1,11:1,111:27,114:1,118:1,14:2,143:2,152:4,163:4,174:7,175:10,176:2,177:4,182:1,183:1,215:13,216:2,218:2,219:2,24:6,25:2,26:6,265:2,28:1,30:6,31:2,32:7,8:1,97:4", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "15", "passesmade": "13", "pos": "forward", "punchSaves": "0", "rating": "6.40", "realtimegame": "904", "realtimeidle": "27", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "2", "tackleattempts": "14", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "PeterSSS"}, "328764988": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "1:3,100:2,101:2,105:1,106:1,107:1,111:28,112:2,115:1,143:2,151:3,152:6,157:4,163:2,174:15,175:10,176:3,177:2,182:4,183:1,211:2,212:2,215:9,216:8,219:4,24:6,25:4,27:1,28:2,30:4,31:6,32:3,34:2,35:2,36:1,37:3,97:13", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "17", "passesmade": "9", "pos": "midfielder", "punchSaves": "0", "rating": "6.50", "realtimegame": "904", "realtimeidle": "6", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "4", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "Wheaterz9"}, "358930192": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "1", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:9,100:2,106:1,107:1,108:1,109:1,111:30,112:3,121:1,124:1,13:1,140:1,143:2,152:3,163:7,164:1,174:8,175:6,176:1,177:2,178:2,182:4,183:1,184:1,188:1,19:1,195:1,197:1,201:1,211:1,212:3,214:1,215:7,216:3,217:1,218:1,219:2,229:1,24:4,25:1,26:2,265:1", "match_event_aggregate_1": "266:1,27:2,28:1,30:4,31:2,32:2,34:1,35:1,5:1,6:1,8:1,97:10", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "10", "passesmade": "7", "pos": "midfielder", "punchSaves": "0", "rating": "6.60", "realtimegame": "904", "realtimeidle": "4", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "2", "tackleattempts": "14", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "Shootyk1nz"}, "1086023178": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:6,100:1,101:8,111:11,121:1,14:1,143:4,152:7,157:2,158:1,163:5,164:1,174:19,175:11,176:1,177:3,182:7,186:1,195:1,196:1,211:1,215:16,216:6,218:1,219:9,229:1,24:8,25:4,26:7,265:1,28:1,30:8,31:4,32:4,34:4,35:2,37:2,6:1,8:1,97:12", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "22", "passesmade": "16", "pos": "midfielder", "punchSaves": "0", "rating": "6.90", "realtimegame": "904", "realtimeidle": "7", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "1", "tackleattempts": "12", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "Durzonate"}, "1726290172": {"archetypeid": "8", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "5", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:1,10:1,100:1,105:1,108:1,110:1,111:31,112:3,121:1,143:4,152:7,162:1,163:1,164:1,174:14,175:7,176:5,177:3,182:2,183:1,212:1,215:15,216:2,219:2,229:1,24:4,25:1,26:8,27:1,28:3,30:11,31:2,32:3,34:1,6:3,97:4,99:1", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "18", "passesmade": "15", "pos": "midfielder", "punchSaves": "0", "rating": "6.50", "realtimegame": "905", "realtimeidle": "5", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "2", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "07_DoctorWho"}}, "19229": {"267850381": {"archetypeid": "10", "assists": "1", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,100:1,101:5,102:6,107:2,109:1,11:1,110:1,111:17,112:1,114:2,121:1,143:3,145:1,151:1,156:1,157:2,164:1,174:10,175:8,176:1,177:1,179:1,182:4,183:1,211:1,212:2,215:10,216:4,219:12,229:1,24:8,25:1,26:1,27:1,29:1,30:1,31:2,32:3,34:6,35:2,36:1,37:1", "match_event_aggregate_1": "39:1,6:1,97:8", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "14", "passesmade": "10", "pos": "midfielder", "punchSaves": "0", "rating": "7.00", "realtimegame": "905", "realtimeidle": "55", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "5", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "1", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "ArfaJai"}, "299074481": {"archetypeid": "13", "assists": "2", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "2", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:2,1:2,101:5,11:2,110:1,111:18,114:3,118:2,12:1,121:2,124:1,13:2,134:1,14:1,143:5,152:7,158:1,163:2,164:2,174:8,175:8,176:2,177:4,178:1,182:2,184:1,19:1,211:2,214:2,215:10,216:4,217:2,218:2,219:5,229:2,24:6,25:3,26:3,265:5,27:1,28:1,30:6,31:3,32:3", "match_event_aggregate_1": "33:1,34:1,8:3,97:5", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "1", "namespace": "1", "parrySaves": "0", "passattempts": "14", "passesmade": "10", "pos": "forward", "punchSaves": "0", "rating": "10.00", "realtimegame": "905", "realtimeidle": "12", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "5", "secondsPlayed": "5500", "shots": "4", "tackleattempts": "4", "tacklesmade": "2", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "call_me_Kei"}, "873649125": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,1:4,101:2,106:1,107:3,108:1,109:2,110:1,111:24,112:5,114:2,115:1,121:1,143:6,145:3,151:1,152:3,157:6,163:2,164:1,174:13,175:14,176:4,177:1,178:3,179:1,182:4,204:1,211:2,212:4,215:16,216:7,219:2,229:1,24:5,25:3,26:7,265:1,28:2,30:11,31:2,32:2,34:3", "match_event_aggregate_1": "35:5,36:2,37:4,4:1,5:2,6:1,8:1,97:11", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "23", "passesmade": "16", "pos": "midfielder", "punchSaves": "0", "rating": "7.50", "realtimegame": "905", "realtimeidle": "5", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "5", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "7", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "GarrettGS_029"}, "918108159": {"archetypeid": "7", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "100:4,109:1,111:25,112:3,143:2,152:6,174:17,175:4,176:3,177:2,182:9,186:1,215:17,216:2,219:4,24:7,25:1,26:7,265:1,27:1,28:3,30:12,31:1,32:1,34:4,35:1,5:1,6:6,97:8", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "19", "passesmade": "17", "pos": "midfielder", "punchSaves": "0", "rating": "7.50", "realtimegame": "905", "realtimeidle": "3", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "5", "secondsPlayed": "5500", "shots": "0", "tackleattempts": "0", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "GaRyTrue"}, "986512829": {"archetypeid": "13", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5500", "goals": "3", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "107:2,109:1,110:1,111:25,112:2,12:1,126:2,13:5,131:2,143:4,151:4,157:2,163:1,174:15,175:9,176:7,177:4,182:1,184:1,202:1,211:2,214:3,215:7,216:8,217:5,24:6,25:4,26:1,265:2,27:1,29:1,30:4,31:6,32:2,34:1,35:2,37:2,6:1,93:1,97:10", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "15", "passesmade": "7", "pos": "forward", "punchSaves": "0", "rating": "10.00", "realtimegame": "905", "realtimeidle": "12", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "5", "secondsPlayed": "5500", "shots": "5", "tackleattempts": "3", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "Jeff_DrLecter"}}}, "aggregate": {"19798": {"archetypeid": 68, "assists": 1, "ballDiveSaves": 0, "cleansheetsany": 0, "cleansheetsdef": 0, "cleansheetsgk": 0, "crossSaves": 0, "gameTime": 38500, "goals": 1, "goalsconceded": 35, "goodDirectionSaves": 0, "losses": 7, "match_event_aggregate_0": 0, "match_event_aggregate_1": 0, "match_event_aggregate_2": 0, "match_event_aggregate_3": 0, "mom": 0, "namespace": 21, "parrySaves": 0, "passattempts": 100, "passesmade": 75, "pos": 0, "punchSaves": 0, "rating": 44.8, "realtimegame": 6329, "realtimeidle": 59, "redcards": 0, "reflexSaves": 0, "saves": 0, "SCORE": 7, "secondsPlayed": 38500, "shots": 5, "tackleattempts": 55, "tacklesmade": 4, "userResult": 0, "vproattr": 0, "vprohackreason": 0, "wins": 0}, "19229": {"archetypeid": 54, "assists": 3, "ballDiveSaves": 0, "cleansheetsany": 0, "cleansheetsdef": 0, "cleansheetsgk": 0, "crossSaves": 0, "gameTime": 27500, "goals": 5, "goalsconceded": 5, "goodDirectionSaves": 0, "losses": 0, "match_event_aggregate_0": 0, "match_event_aggregate_1": 0, "match_event_aggregate_2": 0, "match_event_aggregate_3": 0, "mom": 1, "namespace": 5, "parrySaves": 0, "passattempts": 85, "passesmade": 60, "pos": 0, "punchSaves": 0, "rating": 42.0, "realtimegame": 4525, "realtimeidle": 87, "redcards": 0, "reflexSaves": 0, "saves": 0, "SCORE": 25, "secondsPlayed": 27500, "shots": 9, "tackleattempts": 15, "tacklesmade": 4, "userResult": 0, "vproattr": 0, "vprohackreason": 0, "wins": 5}}}','2025-09-18 21:01:15');
INSERT INTO matches VALUES('1888675220269',1758226637,NULL,39,'minutes','{"matchId": "1888675220269", "timestamp": 1758226637, "timeAgo": {"number": 39, "unit": "minutes"}, "clubs": {"19798": {"date": "1758226637", "gameNumber": "0", "goals": "3", "goalsAgainst": "1", "losses": "0", "matchType": "1", "result": "1", "score": "3", "season_id": "0", "TEAM": "480", "ties": "0", "winnerByDnf": "0", "wins": "1", "details": {"name": "Rayo Vilkins", "clubId": 19798, "regionId": 5723475, "teamId": 480, "customKit": {"stadName": "Estadio de Vallecas", "kitId": "3932160", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160807"}}}, "27205": {"date": "1758226637", "gameNumber": "0", "goals": "1", "goalsAgainst": "3", "losses": "1", "matchType": "1", "result": "2", "score": "1", "season_id": "0", "TEAM": "241", "ties": "0", "winnerByDnf": "0", "wins": "0", "details": {"name": "GoalDiggers FC", "clubId": 27205, "regionId": 5456211, "teamId": 241, "customKit": {"stadName": "Gtech Community Stadium", "kitId": "1974272", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160912"}}}}, "players": {"19798": {"182482543": {"archetypeid": "8", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "1:1,100:3,111:27,114:1,143:1,145:2,152:4,157:2,174:5,175:4,177:1,182:4,215:7,216:2,219:3,24:1,25:1,26:4,28:1,30:4,31:1,32:2,34:1,35:1,36:1,37:1,97:2", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "9", "passesmade": "7", "pos": "defender", "punchSaves": "0", "rating": "6.20", "realtimegame": "919", "realtimeidle": "8", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "2", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "DerBones"}, "212960503": {"archetypeid": "7", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,1:4,100:2,105:2,108:2,109:1,111:26,112:2,121:1,143:2,152:3,158:1,163:4,164:1,174:10,175:6,176:2,177:2,181:1,182:2,183:1,212:2,215:9,216:3,219:2,229:1,24:6,25:2,28:3,30:6,31:2,32:2,34:1,5:1,6:6,9:1,97:3", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "12", "passesmade": "9", "pos": "midfielder", "punchSaves": "0", "rating": "7.30", "realtimegame": "919", "realtimeidle": "11", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "6", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "rv-Doggie"}, "248203001": {"archetypeid": "12", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "2", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "1:7,100:1,106:1,110:1,111:21,12:1,13:2,143:1,152:5,163:5,17:1,174:7,175:6,176:3,177:2,18:1,183:1,212:1,214:2,215:7,216:1,217:3,219:1,238:1,24:5,25:1,26:1,265:1,28:1,30:2,31:1,32:2,34:3,6:1,7:1,97:4", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "8", "passesmade": "7", "pos": "forward", "punchSaves": "0", "rating": "8.00", "realtimegame": "919", "realtimeidle": "22", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "3", "tackleattempts": "9", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "PeterSSS"}, "328764988": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "1", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,1:3,100:1,101:4,106:2,108:1,109:1,110:1,111:21,112:4,121:1,128:1,13:1,131:1,140:1,152:8,153:1,157:2,163:1,164:1,174:25,175:8,176:5,177:3,178:1,181:1,182:8,183:1,211:3,212:1,214:1,215:15,216:8,217:1,219:5,229:1,24:9,25:6,26:4,28:2,30:8,31:4,32:3", "match_event_aggregate_1": "33:1,34:5,35:2,37:1,6:3,9:1,97:16", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "1", "namespace": "3", "parrySaves": "0", "passattempts": "26", "passesmade": "16", "pos": "midfielder", "punchSaves": "0", "rating": "8.40", "realtimegame": "919", "realtimeidle": "9", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "1", "tackleattempts": "5", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "Wheaterz9"}, "358930192": {"archetypeid": "11", "assists": "1", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "1:4,100:2,107:1,11:1,111:31,112:1,114:1,152:2,157:1,163:3,174:6,175:4,18:1,182:1,183:3,204:1,215:4,216:1,217:1,219:2,24:3,25:1,30:1,32:1,34:2,35:1,36:1,4:1,97:5", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "5", "passesmade": "4", "pos": "midfielder", "punchSaves": "0", "rating": "6.70", "realtimegame": "919", "realtimeidle": "3", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "1", "tackleattempts": "4", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "Shootyk1nz"}, "1086023178": {"archetypeid": "11", "assists": "1", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "1:5,101:3,102:5,107:1,11:1,111:4,112:1,114:1,115:1,118:1,143:2,152:6,157:2,163:1,174:17,175:10,176:1,177:2,178:1,179:1,182:6,183:1,188:1,19:1,190:1,192:1,202:1,211:1,212:1,215:13,216:7,218:1,219:8,24:3,25:3,26:8,265:1,27:1,28:2,30:9,31:2,32:2,34:2", "match_event_aggregate_1": "35:4,37:2,6:1,8:1,9:1,97:13", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "20", "passesmade": "13", "pos": "midfielder", "punchSaves": "0", "rating": "8.00", "realtimegame": "919", "realtimeidle": "8", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "1", "tackleattempts": "11", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "Durzonate"}, "1726290172": {"archetypeid": "8", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:2,1:2,100:1,105:1,106:1,108:1,109:1,111:25,112:1,114:1,115:1,121:2,143:3,152:7,158:1,163:2,164:2,174:16,175:11,176:5,177:4,186:1,207:1,215:16,216:4,219:1,229:2,24:7,25:3,26:7,28:2,30:11,31:1,32:4,34:1,35:2,6:5,97:6", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "20", "passesmade": "16", "pos": "midfielder", "punchSaves": "0", "rating": "7.30", "realtimegame": "920", "realtimeidle": "3", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "3", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "4", "tacklesmade": "2", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "07_DoctorWho"}}, "27205": {"1915386874": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "3", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "1:1,101:4,109:1,110:1,111:16,143:7,150:1,151:1,152:1,174:10,175:9,176:2,177:1,182:5,184:1,215:15,216:3,219:5,24:11,25:3,26:2,265:3,266:2,28:1,3:1,30:2,31:2,32:6,34:6,35:1,6:4,8:4,9:1,95:1,97:4,99:1", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "18", "passesmade": "14", "pos": "midfielder", "punchSaves": "0", "rating": "6.40", "realtimegame": "920", "realtimeidle": "5", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "2", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "ShreyChoudhary98"}, "1004042427028": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "1", "goalsconceded": "3", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:2,1:2,100:1,101:3,107:3,110:1,111:16,112:6,121:2,13:2,143:5,151:1,152:2,153:1,158:1,163:2,164:2,17:1,174:16,175:13,176:3,177:2,18:1,182:3,183:1,196:1,202:1,211:3,212:1,214:1,215:14,216:3,217:3,219:4,229:2,238:1,24:11,25:2,26:4,29:1,30:5,31:3,32:8", "match_event_aggregate_1": "34:2,5:1,6:1,97:8", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "18", "passesmade": "15", "pos": "midfielder", "punchSaves": "0", "rating": "7.40", "realtimegame": "920", "realtimeidle": "6", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5479", "shots": "3", "tackleattempts": "4", "tacklesmade": "2", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "NewdsOnly"}, "1004799042838": {"archetypeid": "10", "assists": "1", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "3", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "1:8,100:1,101:2,102:9,104:1,106:3,109:1,11:1,111:14,112:2,14:1,145:2,163:4,174:12,175:7,177:3,182:5,183:1,190:1,202:1,212:2,215:10,216:3,218:1,219:13,24:9,25:3,26:1,30:5,31:3,32:4,34:1,5:1,6:2,8:1,97:12,99:1", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "13", "passesmade": "10", "pos": "midfielder", "punchSaves": "0", "rating": "7.00", "realtimegame": "920", "realtimeidle": "20", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5479", "shots": "1", "tackleattempts": "10", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "Rifty1337"}, "1006817278526": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "3", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:2,1:4,101:6,106:1,107:6,110:1,111:13,114:1,121:2,143:1,151:1,152:5,158:2,163:2,164:2,174:7,175:10,177:2,179:1,183:1,184:5,211:1,212:4,215:9,216:3,219:7,229:2,24:6,25:3,26:2,28:1,30:4,31:3,32:4,34:1,39:3,97:12,99:1", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "12", "passesmade": "9", "pos": "forward", "punchSaves": "0", "rating": "5.60", "realtimegame": "920", "realtimeidle": "0", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "7", "tacklesmade": "2", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "good-zilla7"}, "1006839645839": {"archetypeid": "12", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "3", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,10:1,101:2,102:15,106:4,108:1,109:1,111:6,112:1,114:1,115:1,121:1,143:8,151:1,152:11,164:1,174:16,175:15,176:1,177:1,182:8,183:1,215:19,216:5,219:18,229:1,24:11,25:3,26:7,27:1,28:1,29:1,30:17,31:4,32:1,33:1,34:1,6:2,97:13,99:1", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "24", "passesmade": "19", "pos": "midfielder", "punchSaves": "0", "rating": "6.60", "realtimegame": "920", "realtimeidle": "0", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "1", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "Rajnikanthh_8106"}, "1007957209335": {"archetypeid": "8", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5479", "goals": "0", "goalsconceded": "3", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:5,101:7,105:1,108:1,111:15,112:3,121:1,143:1,152:1,163:4,164:1,174:16,175:8,176:3,177:3,182:4,183:1,215:16,216:2,219:7,229:1,24:9,25:1,26:7,266:1,27:1,30:9,31:2,32:2,34:5,6:5,8:1,97:7", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "18", "passesmade": "16", "pos": "midfielder", "punchSaves": "0", "rating": "7.00", "realtimegame": "920", "realtimeidle": "24", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5479", "shots": "0", "tackleattempts": "9", "tacklesmade": "2", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "THUNDERxEVIL"}}}, "aggregate": {"19798": {"archetypeid": 68, "assists": 2, "ballDiveSaves": 0, "cleansheetsany": 0, "cleansheetsdef": 0, "cleansheetsgk": 0, "crossSaves": 0, "gameTime": 38353, "goals": 3, "goalsconceded": 7, "goodDirectionSaves": 0, "losses": 0, "match_event_aggregate_0": 0, "match_event_aggregate_1": 0, "match_event_aggregate_2": 0, "match_event_aggregate_3": 0, "mom": 1, "namespace": 21, "parrySaves": 0, "passattempts": 100, "passesmade": 72, "pos": 0, "punchSaves": 0, "rating": 51.9, "realtimegame": 6434, "realtimeidle": 64, "redcards": 0, "reflexSaves": 0, "saves": 0, "SCORE": 21, "secondsPlayed": 38353, "shots": 6, "tackleattempts": 41, "tacklesmade": 4, "userResult": 0, "vproattr": 0, "vprohackreason": 0, "wins": 7}, "27205": {"archetypeid": 63, "assists": 1, "ballDiveSaves": 0, "cleansheetsany": 0, "cleansheetsdef": 0, "cleansheetsgk": 0, "crossSaves": 0, "gameTime": 32874, "goals": 1, "goalsconceded": 18, "goodDirectionSaves": 0, "losses": 6, "match_event_aggregate_0": 0, "match_event_aggregate_1": 0, "match_event_aggregate_2": 0, "match_event_aggregate_3": 0, "mom": 0, "namespace": 6, "parrySaves": 0, "passattempts": 103, "passesmade": 83, "pos": 0, "punchSaves": 0, "rating": 40.0, "realtimegame": 5520, "realtimeidle": 55, "redcards": 0, "reflexSaves": 0, "saves": 0, "SCORE": 6, "secondsPlayed": 32874, "shots": 4, "tackleattempts": 33, "tacklesmade": 7, "userResult": 0, "vproattr": 0, "vprohackreason": 0, "wins": 0}}}','2025-09-18 21:01:15');
INSERT INTO matches VALUES('1910522590438',1758225261,NULL,1,'hours','{"matchId": "1910522590438", "timestamp": 1758225261, "timeAgo": {"number": 1, "unit": "hours"}, "clubs": {"19798": {"date": "1758225260", "gameNumber": "0", "goals": "1", "goalsAgainst": "0", "losses": "0", "matchType": "1", "result": "1", "score": "1", "season_id": "0", "TEAM": "480", "ties": "0", "winnerByDnf": "0", "wins": "1", "details": {"name": "Rayo Vilkins", "clubId": 19798, "regionId": 5723475, "teamId": 480, "customKit": {"stadName": "Estadio de Vallecas", "kitId": "3932160", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160807"}}}, "26645": {"date": "1758225260", "gameNumber": "0", "goals": "0", "goalsAgainst": "1", "losses": "1", "matchType": "1", "result": "2", "score": "0", "season_id": "0", "TEAM": "99160821", "ties": "0", "winnerByDnf": "0", "wins": "0", "details": {"name": "JB United", "clubId": 26645, "regionId": 4804164, "teamId": 1, "customKit": {"stadName": "Tier 1 Stadium", "kitId": "8192", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "1", "customKitId": "7534", "customAwayKitId": "7517", "customThirdKitId": "7514", "customKeeperKitId": "5005", "kitColor1": "14655653", "kitColor2": "592397", "kitColor3": "14935011", "kitColor4": "15921906", "kitAColor1": "858211", "kitAColor2": "6379598", "kitAColor3": "14655653", "kitAColor4": "15921906", "kitThrdColor1": "16774144", "kitThrdColor2": "6379598", "kitThrdColor3": "1256053", "kitThrdColor4": "1256053", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160821"}}}}, "players": {"19798": {"212960503": {"archetypeid": "7", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "1", "goalsconceded": "0", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,100:3,107:1,109:2,111:33,112:1,113:1,12:1,121:1,136:1,14:1,143:2,151:1,152:2,16:1,164:1,174:11,175:4,176:3,177:2,179:1,182:3,183:1,214:1,215:8,216:4,218:1,219:3,229:1,24:3,25:1,26:5,266:2,27:2,29:1,30:5,31:4,32:1,34:2,5:1,6:3,8:1,97:5", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "12", "passesmade": "8", "pos": "midfielder", "punchSaves": "0", "rating": "8.10", "realtimegame": "889", "realtimeidle": "11", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5575", "shots": "1", "tackleattempts": "2", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "rv-Doggie"}, "248203001": {"archetypeid": "12", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "0", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,1:9,100:1,106:1,107:3,109:1,110:1,111:20,112:2,113:1,114:3,121:1,13:4,14:1,143:2,151:2,152:6,157:1,158:1,163:6,164:1,174:18,175:11,176:5,177:4,178:1,179:1,182:2,183:1,184:1,186:1,202:2,212:2,215:13,216:4,217:4,218:1,219:1,229:1,24:6,25:1,26:7", "match_event_aggregate_1": "265:2,27:2,30:8,31:3,32:1,34:4,35:1,37:1,6:2,8:1,97:11", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "17", "passesmade": "13", "pos": "forward", "punchSaves": "0", "rating": "6.60", "realtimegame": "889", "realtimeidle": "10", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5575", "shots": "5", "tackleattempts": "23", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "PeterSSS"}, "328764988": {"archetypeid": "8", "assists": "1", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "0", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "0:1,1:1,100:1,101:3,105:2,106:3,107:2,108:1,11:1,110:1,111:25,112:2,113:1,114:2,121:1,14:1,143:5,145:5,151:3,152:9,153:2,157:8,163:1,164:1,174:24,175:16,176:5,177:6,182:10,183:3,184:1,202:1,212:5,215:21,216:13,218:1,219:4,229:1,24:12,25:4,26:4,265:1", "match_event_aggregate_1": "27:2,28:4,30:9,31:6,32:6,34:6,35:7,36:1,37:7,5:1,6:2,8:2,97:26", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "1", "namespace": "3", "parrySaves": "0", "passattempts": "34", "passesmade": "21", "pos": "midfielder", "punchSaves": "0", "rating": "8.70", "realtimegame": "889", "realtimeidle": "16", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5575", "shots": "1", "tackleattempts": "3", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "Wheaterz9"}, "358930192": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "0", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "1:6,100:4,107:5,111:28,113:1,143:2,144:1,152:6,163:5,174:12,175:8,176:2,177:2,181:1,182:2,183:3,188:1,19:1,190:1,192:1,202:1,212:3,215:11,216:2,218:1,219:4,24:4,25:2,26:5,266:1,28:2,30:7,31:1,32:1,34:3,35:1,8:1,97:15", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "13", "passesmade": "11", "pos": "midfielder", "punchSaves": "0", "rating": "6.90", "realtimegame": "889", "realtimeidle": "2", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5575", "shots": "1", "tackleattempts": "7", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "Shootyk1nz"}, "1086023178": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "0", "goals": "0", "goalsconceded": "0", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "0", "passesmade": "0", "pos": "midfielder", "punchSaves": "0", "rating": "3.00", "realtimegame": "0", "realtimeidle": "0", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "0", "shots": "0", "tackleattempts": "0", "tacklesmade": "0", "userResult": "0", "vproattr": "", "vprohackreason": "0", "wins": "1", "playername": "Durzonate"}, "1726290172": {"archetypeid": "8", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "0", "goodDirectionSaves": "0", "losses": "0", "match_event_aggregate_0": "1:1,100:1,101:1,108:1,111:24,112:1,113:1,119:1,143:3,152:7,163:1,174:17,175:7,176:7,177:2,181:1,182:4,211:1,215:21,219:2,24:13,26:7,266:1,28:1,30:11,32:6,34:4,38:1,5:1,6:5,8:1,97:7", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "3", "parrySaves": "0", "passattempts": "21", "passesmade": "21", "pos": "midfielder", "punchSaves": "0", "rating": "7.10", "realtimegame": "889", "realtimeidle": "8", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "1", "secondsPlayed": "5575", "shots": "0", "tackleattempts": "1", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "1", "playername": "07_DoctorWho"}}, "26645": {"855004091": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:2,1:3,100:2,101:6,102:6,105:1,106:1,107:3,109:2,111:23,112:1,119:1,121:2,143:3,152:3,157:1,158:1,163:2,164:2,174:9,175:6,176:2,178:1,182:4,183:4,19:1,211:2,212:3,215:8,216:3,218:1,219:14,229:2,24:3,25:3,26:3,265:1,28:1,30:6,31:2,34:2,35:1,36:1,38:1", "match_event_aggregate_1": "6:2,8:2,97:10", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "11", "passesmade": "8", "pos": "forward", "punchSaves": "0", "rating": "6.30", "realtimegame": "889", "realtimeidle": "9", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "0", "secondsPlayed": "5575", "shots": "1", "tackleattempts": "7", "tacklesmade": "2", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "OhmyGAARD"}, "984105975": {"archetypeid": "10", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:5,100:1,106:2,108:1,111:33,121:1,13:1,145:1,152:5,157:1,158:1,163:1,164:1,174:11,175:3,177:4,178:1,182:4,183:1,186:1,202:1,211:2,215:7,216:4,217:1,219:1,229:1,24:1,25:3,26:4,28:2,30:6,31:3,33:1,34:1,37:1,97:8", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "11", "passesmade": "7", "pos": "midfielder", "punchSaves": "0", "rating": "6.10", "realtimegame": "10371", "realtimeidle": "3", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "0", "secondsPlayed": "5575", "shots": "1", "tackleattempts": "6", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "boss-875"}, "1260149393": {"archetypeid": "11", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "0:1,1:4,100:1,101:4,102:5,105:1,106:2,107:2,111:15,121:1,14:1,143:4,151:1,152:8,158:1,163:2,164:1,174:13,175:12,176:1,177:4,182:2,183:2,19:1,195:1,212:2,215:12,216:4,218:2,219:10,229:1,24:6,25:3,26:5,265:3,27:1,28:1,30:11,31:3,34:1,35:1,8:1,97:12", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "16", "passesmade": "12", "pos": "forward", "punchSaves": "0", "rating": "6.50", "realtimegame": "9338", "realtimeidle": "2", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "0", "secondsPlayed": "5575", "shots": "2", "tackleattempts": "6", "tacklesmade": "1", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "winny247"}, "1008509852299": {"archetypeid": "12", "assists": "0", "ballDiveSaves": "0", "cleansheetsany": "0", "cleansheetsdef": "0", "cleansheetsgk": "0", "crossSaves": "0", "gameTime": "5575", "goals": "0", "goalsconceded": "1", "goodDirectionSaves": "0", "losses": "1", "match_event_aggregate_0": "1:4,100:3,107:3,110:1,111:29,114:1,14:1,143:3,150:1,152:7,163:2,174:12,175:13,176:3,177:1,179:1,182:1,19:1,195:1,196:1,200:1,211:2,212:1,215:12,216:3,218:2,219:4,24:9,25:3,26:3,265:2,30:6,31:3,32:3,34:3,8:2,97:10,99:1", "match_event_aggregate_1": "", "match_event_aggregate_2": "", "match_event_aggregate_3": "", "mom": "0", "namespace": "1", "parrySaves": "0", "passattempts": "15", "passesmade": "12", "pos": "forward", "punchSaves": "0", "rating": "6.40", "realtimegame": "889", "realtimeidle": "6", "redcards": "0", "reflexSaves": "0", "saves": "0", "SCORE": "0", "secondsPlayed": "5575", "shots": "2", "tackleattempts": "4", "tacklesmade": "0", "userResult": "0", "vproattr": "NH", "vprohackreason": "0", "wins": "0", "playername": "pompompiyapat456"}}}, "aggregate": {"19798": {"archetypeid": 57, "assists": 1, "ballDiveSaves": 0, "cleansheetsany": 0, "cleansheetsdef": 0, "cleansheetsgk": 0, "crossSaves": 0, "gameTime": 27875, "goals": 1, "goalsconceded": 0, "goodDirectionSaves": 0, "losses": 0, "match_event_aggregate_0": 0, "match_event_aggregate_1": 0, "match_event_aggregate_2": 0, "match_event_aggregate_3": 0, "mom": 1, "namespace": 18, "parrySaves": 0, "passattempts": 97, "passesmade": 74, "pos": 0, "punchSaves": 0, "rating": 40.4, "realtimegame": 4445, "realtimeidle": 47, "redcards": 0, "reflexSaves": 0, "saves": 0, "SCORE": 6, "secondsPlayed": 27875, "shots": 8, "tackleattempts": 36, "tacklesmade": 3, "userResult": 0, "vproattr": 0, "vprohackreason": 0, "wins": 6}, "26645": {"archetypeid": 44, "assists": 0, "ballDiveSaves": 0, "cleansheetsany": 0, "cleansheetsdef": 0, "cleansheetsgk": 0, "crossSaves": 0, "gameTime": 22300, "goals": 0, "goalsconceded": 4, "goodDirectionSaves": 0, "losses": 4, "match_event_aggregate_0": 0, "match_event_aggregate_1": 0, "match_event_aggregate_2": 0, "match_event_aggregate_3": 0, "mom": 0, "namespace": 4, "parrySaves": 0, "passattempts": 53, "passesmade": 39, "pos": 0, "punchSaves": 0, "rating": 25.3, "realtimegame": 21487, "realtimeidle": 20, "redcards": 0, "reflexSaves": 0, "saves": 0, "SCORE": 0, "secondsPlayed": 22300, "shots": 6, "tackleattempts": 23, "tacklesmade": 4, "userResult": 0, "vproattr": 0, "vprohackreason": 0, "wins": 0}}}','2025-09-18 21:01:15');
CREATE TABLE match_clubs (
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
INSERT INTO match_clubs VALUES(1,'1934776370243','19229','Con9sole','1758227724','0',5,1,0,1,1,5,'0','21',0,0,1,'4281153','Console game','172032','99160401','{"stadName": "Console game", "kitId": "172032", "seasonalTeamId": "0", "seasonalKitId": "0", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160401"}');
INSERT INTO match_clubs VALUES(2,'1934776370243','19798','Rayo Vilkins','1758227724','0',1,5,1,1,2,1,'0','480',0,0,0,'5723475','Estadio de Vallecas','3932160','99160807','{"stadName": "Estadio de Vallecas", "kitId": "3932160", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160807"}');
INSERT INTO match_clubs VALUES(3,'1888675220269','19798','Rayo Vilkins','1758226637','0',3,1,0,1,1,3,'0','480',0,0,1,'5723475','Estadio de Vallecas','3932160','99160807','{"stadName": "Estadio de Vallecas", "kitId": "3932160", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160807"}');
INSERT INTO match_clubs VALUES(4,'1888675220269','27205','GoalDiggers FC','1758226637','0',1,3,1,1,2,1,'0','241',0,0,0,'5456211','Gtech Community Stadium','1974272','99160912','{"stadName": "Gtech Community Stadium", "kitId": "1974272", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160912"}');
INSERT INTO match_clubs VALUES(5,'1910522590438','19798','Rayo Vilkins','1758225260','0',1,0,0,1,1,1,'0','480',0,0,1,'5723475','Estadio de Vallecas','3932160','99160807','{"stadName": "Estadio de Vallecas", "kitId": "3932160", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "0", "customKitId": "7509", "customAwayKitId": "7509", "customThirdKitId": "7511", "customKeeperKitId": "5005", "kitColor1": "15921906", "kitColor2": "592397", "kitColor3": "592397", "kitColor4": "592397", "kitAColor1": "592397", "kitAColor2": "15921906", "kitAColor3": "15921906", "kitAColor4": "15921906", "kitThrdColor1": "12706617", "kitThrdColor2": "33627", "kitThrdColor3": "396864", "kitThrdColor4": "2164288", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160807"}');
INSERT INTO match_clubs VALUES(6,'1910522590438','26645','JB United','1758225260','0',0,1,1,1,2,0,'0','99160821',0,0,0,'4804164','Tier 1 Stadium','8192','99160821','{"stadName": "Tier 1 Stadium", "kitId": "8192", "seasonalTeamId": "131397", "seasonalKitId": "1076404224", "selectedKitType": "1", "customKitId": "7534", "customAwayKitId": "7517", "customThirdKitId": "7514", "customKeeperKitId": "5005", "kitColor1": "14655653", "kitColor2": "592397", "kitColor3": "14935011", "kitColor4": "15921906", "kitAColor1": "858211", "kitAColor2": "6379598", "kitAColor3": "14655653", "kitAColor4": "15921906", "kitThrdColor1": "16774144", "kitThrdColor2": "6379598", "kitThrdColor3": "1256053", "kitThrdColor4": "1256053", "dCustomKit": "0", "crestColor": "-1", "crestAssetId": "99160821"}');
CREATE TABLE match_players (
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
INSERT INTO match_players VALUES(1,'1934776370243','19798','182482543','DerBones',0,0,0,0,0,5,1,0,3,9,8,'defender',6.09999999999999964,904,6,0,0,1,0,3,0,0,'NH','0');
INSERT INTO match_players VALUES(2,'1934776370243','19798','212960503','rv-Doggie',0,0,0,0,0,5,1,0,3,9,7,'midfielder',5.79999999999999982,904,4,0,0,1,0,6,1,0,'NH','0');
INSERT INTO match_players VALUES(3,'1934776370243','19798','248203001','PeterSSS',1,0,0,0,0,5,1,0,3,15,13,'forward',6.40000000000000035,904,27,0,0,1,2,14,0,0,'NH','0');
INSERT INTO match_players VALUES(4,'1934776370243','19798','328764988','Wheaterz9',0,0,0,0,0,5,1,0,3,17,9,'midfielder',6.5,904,6,0,0,1,0,4,0,0,'NH','0');
INSERT INTO match_players VALUES(5,'1934776370243','19798','358930192','Shootyk1nz',0,0,0,0,1,5,1,0,3,10,7,'midfielder',6.59999999999999964,904,4,0,0,1,2,14,1,0,'NH','0');
INSERT INTO match_players VALUES(6,'1934776370243','19798','1086023178','Durzonate',0,0,0,0,0,5,1,0,3,22,16,'midfielder',6.90000000000000035,904,7,0,0,1,1,12,1,0,'NH','0');
INSERT INTO match_players VALUES(7,'1934776370243','19798','1726290172','07_DoctorWho',0,0,0,0,0,5,1,0,3,18,15,'midfielder',6.5,905,5,0,0,1,0,2,1,0,'NH','0');
INSERT INTO match_players VALUES(8,'1934776370243','19229','267850381','ArfaJai',1,0,0,0,0,1,0,0,1,14,10,'midfielder',7.0,905,55,0,0,5,0,1,1,1,'NH','0');
INSERT INTO match_players VALUES(9,'1934776370243','19229','299074481','call_me_Kei',2,0,0,0,2,1,0,1,1,14,10,'forward',10.0,905,12,0,0,5,4,4,2,1,'NH','0');
INSERT INTO match_players VALUES(10,'1934776370243','19229','873649125','GarrettGS_029',0,0,0,0,0,1,0,0,1,23,16,'midfielder',7.5,905,5,0,0,5,0,7,1,1,'NH','0');
INSERT INTO match_players VALUES(11,'1934776370243','19229','918108159','GaRyTrue',0,0,0,0,0,1,0,0,1,19,17,'midfielder',7.5,905,3,0,0,5,0,0,0,1,'NH','0');
INSERT INTO match_players VALUES(12,'1934776370243','19229','986512829','Jeff_DrLecter',0,0,0,0,3,1,0,0,1,15,7,'forward',10.0,905,12,0,0,5,5,3,0,1,'NH','0');
INSERT INTO match_players VALUES(13,'1888675220269','19798','182482543','DerBones',0,0,0,0,0,1,0,0,3,9,7,'defender',6.20000000000000017,919,8,0,0,3,0,2,0,1,'NH','0');
INSERT INTO match_players VALUES(14,'1888675220269','19798','212960503','rv-Doggie',0,0,0,0,0,1,0,0,3,12,9,'midfielder',7.29999999999999982,919,11,0,0,3,0,6,1,1,'NH','0');
INSERT INTO match_players VALUES(15,'1888675220269','19798','248203001','PeterSSS',0,0,0,0,2,1,0,0,3,8,7,'forward',8.0,919,22,0,0,3,3,9,0,1,'NH','0');
INSERT INTO match_players VALUES(16,'1888675220269','19798','328764988','Wheaterz9',0,0,0,0,1,1,0,1,3,26,16,'midfielder',8.40000000000000035,919,9,0,0,3,1,5,1,1,'NH','0');
INSERT INTO match_players VALUES(17,'1888675220269','19798','358930192','Shootyk1nz',1,0,0,0,0,1,0,0,3,5,4,'midfielder',6.70000000000000017,919,3,0,0,3,1,4,0,1,'NH','0');
INSERT INTO match_players VALUES(18,'1888675220269','19798','1086023178','Durzonate',1,0,0,0,0,1,0,0,3,20,13,'midfielder',8.0,919,8,0,0,3,1,11,0,1,'NH','0');
INSERT INTO match_players VALUES(19,'1888675220269','19798','1726290172','07_DoctorWho',0,0,0,0,0,1,0,0,3,20,16,'midfielder',7.29999999999999982,920,3,0,0,3,0,4,2,1,'NH','0');
INSERT INTO match_players VALUES(20,'1888675220269','27205','1915386874','ShreyChoudhary98',0,0,0,0,0,3,1,0,1,18,14,'midfielder',6.40000000000000035,920,5,0,0,1,0,2,0,0,'NH','0');
INSERT INTO match_players VALUES(21,'1888675220269','27205','1004042427028','NewdsOnly',0,0,0,0,1,3,1,0,1,18,15,'midfielder',7.40000000000000035,920,6,0,0,1,3,4,2,0,'NH','0');
INSERT INTO match_players VALUES(22,'1888675220269','27205','1004799042838','Rifty1337',1,0,0,0,0,3,1,0,1,13,10,'midfielder',7.0,920,20,0,0,1,1,10,0,0,'NH','0');
INSERT INTO match_players VALUES(23,'1888675220269','27205','1006817278526','good-zilla7',0,0,0,0,0,3,1,0,1,12,9,'forward',5.59999999999999964,920,0,0,0,1,0,7,2,0,'NH','0');
INSERT INTO match_players VALUES(24,'1888675220269','27205','1006839645839','Rajnikanthh_8106',0,0,0,0,0,3,1,0,1,24,19,'midfielder',6.59999999999999964,920,0,0,0,1,0,1,1,0,'NH','0');
INSERT INTO match_players VALUES(25,'1888675220269','27205','1007957209335','THUNDERxEVIL',0,0,0,0,0,3,1,0,1,18,16,'midfielder',7.0,920,24,0,0,1,0,9,2,0,'NH','0');
INSERT INTO match_players VALUES(26,'1910522590438','19798','212960503','rv-Doggie',0,0,0,0,1,0,0,0,3,12,8,'midfielder',8.09999999999999964,889,11,0,0,1,1,2,1,1,'NH','0');
INSERT INTO match_players VALUES(27,'1910522590438','19798','248203001','PeterSSS',0,0,0,0,0,0,0,0,3,17,13,'forward',6.59999999999999964,889,10,0,0,1,5,23,1,1,'NH','0');
INSERT INTO match_players VALUES(28,'1910522590438','19798','328764988','Wheaterz9',1,0,0,0,0,0,0,1,3,34,21,'midfielder',8.69999999999999929,889,16,0,0,1,1,3,1,1,'NH','0');
INSERT INTO match_players VALUES(29,'1910522590438','19798','358930192','Shootyk1nz',0,0,0,0,0,0,0,0,3,13,11,'midfielder',6.90000000000000035,889,2,0,0,1,1,7,0,1,'NH','0');
INSERT INTO match_players VALUES(30,'1910522590438','19798','1086023178','Durzonate',0,0,0,0,0,0,0,0,3,0,0,'midfielder',3.0,0,0,0,0,1,0,0,0,1,'','0');
INSERT INTO match_players VALUES(31,'1910522590438','19798','1726290172','07_DoctorWho',0,0,0,0,0,0,0,0,3,21,21,'midfielder',7.09999999999999964,889,8,0,0,1,0,1,0,1,'NH','0');
INSERT INTO match_players VALUES(32,'1910522590438','26645','855004091','OhmyGAARD',0,0,0,0,0,1,1,0,1,11,8,'forward',6.29999999999999982,889,9,0,0,0,1,7,2,0,'NH','0');
INSERT INTO match_players VALUES(33,'1910522590438','26645','984105975','boss-875',0,0,0,0,0,1,1,0,1,11,7,'midfielder',6.09999999999999964,10371,3,0,0,0,1,6,1,0,'NH','0');
INSERT INTO match_players VALUES(34,'1910522590438','26645','1260149393','winny247',0,0,0,0,0,1,1,0,1,16,12,'forward',6.5,9338,2,0,0,0,2,6,1,0,'NH','0');
INSERT INTO match_players VALUES(35,'1910522590438','26645','1008509852299','pompompiyapat456',0,0,0,0,0,1,1,0,1,15,12,'forward',6.40000000000000035,889,6,0,0,0,2,4,0,0,'NH','0');
CREATE TABLE match_aggregates (
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
INSERT INTO match_aggregates VALUES(1,'1934776370243','19798',1,0,0,0,1,35,7,0,21,100,75,0,44.7999999999999971,6329,59,0,0,7,5,55,4,0,0,0);
INSERT INTO match_aggregates VALUES(2,'1934776370243','19229',3,0,0,0,5,5,0,1,5,85,60,0,42.0,4525,87,0,0,25,9,15,4,0,0,5);
INSERT INTO match_aggregates VALUES(3,'1888675220269','19798',2,0,0,0,3,7,0,1,21,100,72,0,51.8999999999999985,6434,64,0,0,21,6,41,4,0,0,7);
INSERT INTO match_aggregates VALUES(4,'1888675220269','27205',1,0,0,0,1,18,6,0,6,103,83,0,40.0,5520,55,0,0,6,4,33,7,0,0,0);
INSERT INTO match_aggregates VALUES(5,'1910522590438','19798',1,0,0,0,1,0,0,1,18,97,74,0,40.3999999999999985,4445,47,0,0,6,8,36,3,0,0,6);
INSERT INTO match_aggregates VALUES(6,'1910522590438','26645',0,0,0,0,0,4,4,0,4,53,39,0,25.3000000000000007,21487,20,0,0,0,6,23,4,0,0,0);
CREATE TABLE clubs (
    club_id TEXT PRIMARY KEY,
    club_name TEXT,
    region_id TEXT,
    team_id TEXT,
    stad_name TEXT,
    crest_asset_id TEXT,
    last_seen TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO clubs VALUES('19229','Con9sole','4281153','21','Console game','99160401','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO clubs VALUES('27205','GoalDiggers FC','5456211','241','Gtech Community Stadium','99160912','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO clubs VALUES('19798','Rayo Vilkins','5723475','480','Estadio de Vallecas','99160807','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO clubs VALUES('26645','JB United','4804164','1','Tier 1 Stadium','99160821','2025-09-18 21:01:15','2025-09-18 21:01:15');
CREATE TABLE players (
    player_id TEXT PRIMARY KEY,
    player_name TEXT,
    last_position TEXT,
    last_club_id TEXT,
    last_seen TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO players VALUES('267850381','ArfaJai','midfielder','19229','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('299074481','call_me_Kei','forward','19229','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('873649125','GarrettGS_029','midfielder','19229','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('918108159','GaRyTrue','midfielder','19229','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('986512829','Jeff_DrLecter','forward','19229','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('182482543','DerBones','defender','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1915386874','ShreyChoudhary98','midfielder','27205','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1004042427028','NewdsOnly','midfielder','27205','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1004799042838','Rifty1337','midfielder','27205','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1006817278526','good-zilla7','forward','27205','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1006839645839','Rajnikanthh_8106','midfielder','27205','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1007957209335','THUNDERxEVIL','midfielder','27205','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('212960503','rv-Doggie','midfielder','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('248203001','PeterSSS','forward','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('328764988','Wheaterz9','midfielder','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('358930192','Shootyk1nz','midfielder','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1086023178','Durzonate','midfielder','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1726290172','07_DoctorWho','midfielder','19798','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('855004091','OhmyGAARD','forward','26645','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('984105975','boss-875','midfielder','26645','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1260149393','winny247','forward','26645','2025-09-18 21:01:15','2025-09-18 21:01:15');
INSERT INTO players VALUES('1008509852299','pompompiyapat456','forward','26645','2025-09-18 21:01:15','2025-09-18 21:01:15');
CREATE TABLE fetch_history (
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
INSERT INTO fetch_history VALUES(1,'2025-09-18 21:01:16',3,3,NULL,NULL,NULL,'success',NULL);
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('match_clubs',6);
INSERT INTO sqlite_sequence VALUES('match_players',35);
INSERT INTO sqlite_sequence VALUES('match_aggregates',6);
INSERT INTO sqlite_sequence VALUES('fetch_history',1);
CREATE INDEX idx_match_timestamp ON matches(match_timestamp DESC);
CREATE INDEX idx_club_matches ON match_clubs(club_id, match_id);
CREATE INDEX idx_player_matches ON match_players(player_id, match_id);
CREATE INDEX idx_player_stats ON match_players(goals DESC, assists DESC, rating DESC);
CREATE VIEW player_match_stats_view AS
WITH defender_crossing AS (
    -- Extract crossing attribute (15th position) and standing tackle (25th position)
    SELECT 
        mp.*,
        CASE 
            WHEN mp.pos = 'defender' AND mp.vproattr IS NOT NULL AND mp.vproattr != ''
            THEN CAST(SUBSTR(mp.vproattr, 57, 3) AS INTEGER)  -- Crossing is at position 57-59
            ELSE NULL
        END AS crossing_value,
        CASE 
            WHEN mp.pos = 'midfielder' AND mp.vproattr IS NOT NULL AND mp.vproattr != ''
            THEN CAST(SUBSTR(mp.vproattr, 97, 3) AS INTEGER)  -- Standing Tackle is at position 97-99
            ELSE NULL
        END AS standing_tackle
    FROM match_players mp
),
defender_ranks AS (
    -- Count defenders and rank them by crossing per match/club
    SELECT 
        *,
        COUNT(CASE WHEN pos = 'defender' THEN 1 END) OVER (PARTITION BY match_id, club_id) AS defender_count,
        ROW_NUMBER() OVER (
            PARTITION BY match_id, club_id 
            ORDER BY 
                CASE WHEN pos = 'defender' THEN crossing_value ELSE NULL END DESC,
                player_id  -- Tiebreaker for consistent ordering
        ) AS crossing_rank
    FROM defender_crossing
),
match_results AS (
    -- Add match results (and match_type) for win rate calculations and filtering
    SELECT 
        dr.*,
        mc.result  AS team_result,
        mc.wins    AS team_wins,
        mc.losses  AS team_losses,
        mc.ties    AS team_ties,
        mc.match_type AS match_type            -- <<<<<<<<<<<<<<<<<< ADDED
    FROM defender_ranks dr
    LEFT JOIN match_clubs mc 
      ON dr.match_id = mc.match_id 
     AND dr.club_id  = mc.club_id
),
player_season_stats AS (
    -- Calculate season totals for each player (for per-match calculations)
    SELECT 
        player_id,
        club_id,
        COUNT(*) AS season_matches_played,
        SUM(goals) AS season_total_goals,
        SUM(assists) AS season_total_assists,
        SUM(goals + assists) AS season_goal_contributions,
        SUM(mom) AS season_motm_awards,
        SUM(redcards) AS season_red_cards,
        SUM(shots) AS season_total_shots,
        SUM(passattempts) AS season_total_pass_attempts,
        SUM(passesmade) AS season_total_passes_made,
        SUM(tackleattempts) AS season_total_tackle_attempts,
        SUM(tacklesmade) AS season_total_tackles_made,
        SUM(saves) AS season_total_saves,
        SUM(cleansheetsgk) AS season_clean_sheets_gk,
        SUM(cleansheetsdef) AS season_clean_sheets_def,
        SUM(CASE WHEN team_result = 1 OR team_result = 16385 THEN 1 ELSE 0 END) AS season_wins,
        SUM(CASE WHEN team_result = 2 OR team_result = 10 THEN 1 ELSE 0 END) AS season_losses,
        SUM(CASE WHEN team_result = 4 THEN 1 ELSE 0 END) AS season_draws,
        AVG(rating) AS season_avg_rating
    FROM match_results
    GROUP BY player_id, club_id
)
SELECT 
    mr.*,
    -- Assign specific positions (original logic)
    CASE 
        WHEN mr.pos = 'defender' THEN
            CASE 
                -- 2 or fewer defenders: both are fullbacks
                WHEN mr.defender_count <= 2 THEN 
                    CASE 
                        WHEN crossing_rank = 1 THEN 'RB'
                        WHEN crossing_rank = 2 THEN 'LB'
                    END
                -- 3 or more defenders: top 2 crossing are fullbacks, rest are CBs
                ELSE
                    CASE 
                        WHEN crossing_rank = 1 THEN 'RB'
                        WHEN crossing_rank = 2 THEN 'LB'
                        ELSE 'CB'
                    END
            END
        WHEN mr.pos = 'midfielder' THEN
            CASE 
                WHEN mr.standing_tackle > 78 THEN 'DM'
                ELSE 'AM'
            END
        WHEN mr.pos = 'forward' THEN 'ST'
        WHEN mr.pos = 'goalkeeper' THEN 'GK'
        ELSE mr.pos
    END AS assigned_position,
    
    -- Original calculated fields
    mr.goals + mr.assists AS goal_contributions,
    CASE 
        WHEN mr.goals > 0 OR mr.assists > 0 THEN 1 
        ELSE 0 
    END AS contributed_to_goal,
    
    -- Comprehensive season statistics from aggregation
    pss.season_matches_played,
    pss.season_total_goals,
    pss.season_total_assists,
    pss.season_goal_contributions,
    pss.season_motm_awards,
    pss.season_red_cards,
    pss.season_total_shots,
    pss.season_total_pass_attempts,
    pss.season_total_passes_made,
    pss.season_total_tackle_attempts,
    pss.season_total_tackles_made,
    pss.season_total_saves,
    pss.season_clean_sheets_gk,
    pss.season_clean_sheets_def,
    pss.season_wins,
    pss.season_losses,
    pss.season_draws,
    ROUND(pss.season_avg_rating, 2) AS season_avg_rating,
    
    -- Per match calculations
    ROUND(CAST(pss.season_total_goals AS FLOAT) / pss.season_matches_played, 2) AS goals_per_match,
    ROUND(CAST(pss.season_total_assists AS FLOAT) / pss.season_matches_played, 2) AS assists_per_match,
    ROUND(CAST(pss.season_goal_contributions AS FLOAT) / pss.season_matches_played, 2) AS goal_contributions_per_match,
    ROUND(CAST(pss.season_total_shots AS FLOAT) / pss.season_matches_played, 2) AS shots_per_match,
    ROUND(CAST(pss.season_total_passes_made AS FLOAT) / pss.season_matches_played, 2) AS passes_made_per_match,
    ROUND(CAST(pss.season_total_tackles_made AS FLOAT) / pss.season_matches_played, 2) AS tackles_made_per_match,
    ROUND(CAST(pss.season_red_cards AS FLOAT) / pss.season_matches_played, 2) AS red_cards_per_match,
    
    -- Success rates (percentages)
    ROUND(
        CASE 
            WHEN pss.season_matches_played > 0 
            THEN CAST(pss.season_wins AS FLOAT) / pss.season_matches_played * 100
            ELSE 0 
        END, 1
    ) AS win_rate,

    ROUND(CAST(pss.season_motm_awards AS FLOAT) / pss.season_matches_played * 100, 1) AS motm_rate,
    
    ROUND(
        CASE 
            WHEN pss.season_total_pass_attempts > 0 
            THEN CAST(pss.season_total_passes_made AS FLOAT) / pss.season_total_pass_attempts * 100 
            ELSE 0 
        END, 1
    ) AS pass_success_rate,
    
    ROUND(
        CASE 
            WHEN pss.season_total_tackle_attempts > 0 
            THEN CAST(pss.season_total_tackles_made AS FLOAT) / pss.season_total_tackle_attempts * 100 
            ELSE 0 
        END, 1
    ) AS tackle_success_rate,
    
    ROUND(
        CASE 
            WHEN pss.season_total_shots > 0 
            THEN CAST(pss.season_total_goals AS FLOAT) / pss.season_total_shots * 100 
            ELSE 0 
        END, 1
    ) AS shot_success_rate,
    
    ROUND(CAST(pss.season_clean_sheets_def AS FLOAT) / pss.season_matches_played * 100, 1) AS def_clean_sheets_rate,
    ROUND(CAST(pss.season_clean_sheets_gk AS FLOAT) / pss.season_matches_played * 100, 1) AS gk_clean_sheets_rate,
    ROUND(CAST(pss.season_red_cards AS FLOAT) / pss.season_matches_played * 100, 1) AS red_cards_rate

FROM match_results mr
LEFT JOIN player_season_stats pss 
  ON mr.player_id = pss.player_id 
 AND mr.club_id  = pss.club_id
;
COMMIT;
