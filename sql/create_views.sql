-- Drop the view if it exists
DROP VIEW IF EXISTS player_match_stats_view;

-- Create the enhanced view (original structure + comprehensive stats + match_type)
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
 AND mr.club_id  = pss.club_id;
