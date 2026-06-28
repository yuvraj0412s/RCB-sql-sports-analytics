-- ============================================================================
-- IPL SQL PROJECT
-- Prepared By: Yuvraj Singh
-- ============================================================================



-- ============================================================================
-- OBJECTIVE QUESTIONS
-- ============================================================================



-- ============================================================================
-- Objective Question 1
-- List the different dtypes of columns in table “ball_by_ball”
-- ============================================================================

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'ipl'
AND TABLE_NAME = 'Ball_by_Ball';



-- ============================================================================
-- Objective Question 2
-- Total runs scored by RCB season wise including extra runs
-- ============================================================================

SELECT
    t.Team_Name,
    s.Season_Year,
    SUM(b.Runs_Scored) AS Batting_Runs,
    COALESCE(SUM(er.Extra_Runs),0) AS Extra_Runs,
    SUM(b.Runs_Scored) + COALESCE(SUM(er.Extra_Runs),0) AS Total_Runs
FROM Ball_by_Ball b
JOIN Matches m
    ON b.Match_Id = m.Match_Id
JOIN Season s
    ON m.Season_Id = s.Season_Id
JOIN Team t
    ON b.Team_Batting = t.Team_Id
LEFT JOIN Extra_Runs er
    ON b.Match_Id = er.Match_Id
    AND b.Over_Id = er.Over_Id
    AND b.Ball_Id = er.Ball_Id
WHERE t.Team_Name LIKE '%Bangalore%'
GROUP BY t.Team_Name, s.Season_Year
ORDER BY s.Season_Year;



-- ============================================================================
-- Objective Question 3
-- Players older than 25 during season 2014
-- ============================================================================

SELECT
    COUNT(DISTINCT p.Player_Id) AS Players_Above_25
FROM Player p
JOIN Player_Match pm
    ON p.Player_Id = pm.Player_Id
JOIN Matches m
    ON pm.Match_Id = m.Match_Id
JOIN Season s
    ON m.Season_Id = s.Season_Id
WHERE s.Season_Year = 2014
AND TIMESTAMPDIFF(YEAR, p.DOB, '2014-04-01') > 25;





-- ============================================================================
-- Objective Question 4
-- Matches won by RCB in 2013
-- ============================================================================

SELECT
    t.Team_Name,
    s.Season_Year,
    COUNT(*) AS Matches_Won
FROM Matches m
JOIN Team t
    ON m.Match_Winner = t.Team_Id
JOIN Season s
    ON m.Season_Id = s.Season_Id
WHERE t.Team_Name = 'Royal Challengers Bangalore'
AND s.Season_Year = 2013
GROUP BY t.Team_Name, s.Season_Year;



-- ============================================================================
-- Objective Question 5
-- Top 10 players according to strike rate in last 4 seasons
-- ============================================================================

SELECT
    p.Player_Name,
    ROUND((SUM(b.Runs_Scored) * 100.0) / COUNT(*),2) AS Strike_Rate
FROM Ball_by_Ball b
JOIN Player p
    ON b.Striker = p.Player_Id
JOIN Matches m
    ON b.Match_Id = m.Match_Id
JOIN Season s
    ON m.Season_Id = s.Season_Id
WHERE s.Season_Year >= 2013
GROUP BY p.Player_Name
HAVING COUNT(*) >= 50
ORDER BY Strike_Rate DESC
LIMIT 10;



-- ============================================================================
-- Objective Question 6
-- Average runs scored by each batsman
-- ============================================================================

SELECT
    p.Player_Name,
    ROUND(AVG(b.Runs_Scored),2) AS Average_Runs
FROM Ball_by_Ball b
JOIN Player p
    ON b.Striker = p.Player_Id
GROUP BY p.Player_Name
ORDER BY Average_Runs DESC;



-- ============================================================================
-- Objective Question 7
-- Average wickets taken by each bowler
-- ============================================================================

SELECT
    pb.Player_Name AS Bowler,
    COUNT(*) AS Total_Wickets,
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT w.Match_Id),
        2
    ) AS Average_Wickets
FROM Wicket_Taken w
JOIN Ball_by_Ball b
    ON w.Match_Id = b.Match_Id
    AND w.Over_Id = b.Over_Id
    AND w.Ball_Id = b.Ball_Id
JOIN Player pb
    ON b.Bowler = pb.Player_Id
GROUP BY pb.Player_Name
HAVING COUNT(DISTINCT w.Match_Id) >= 10
ORDER BY Average_Wickets DESC;



-- ============================================================================
-- Objective Question 8
-- Players performing well in batting and bowling
-- ============================================================================

WITH Batting AS (
    SELECT
        Striker AS Player_Id,
        AVG(Runs_Scored) AS Avg_Runs
    FROM Ball_by_Ball
    GROUP BY Striker
),
Bowling AS (
    SELECT
        b.Bowler AS Player_Id,
        COUNT(*) * 1.0 / COUNT(DISTINCT w.Match_Id) AS Avg_Wickets
    FROM Ball_by_Ball b
    JOIN Wicket_Taken w
        ON b.Match_Id = w.Match_Id
        AND b.Over_Id = w.Over_Id
        AND b.Ball_Id = w.Ball_Id
    GROUP BY b.Bowler
)

SELECT
    p.Player_Name,
    ba.Avg_Runs,
    bo.Avg_Wickets
FROM Batting ba
JOIN Bowling bo
    ON ba.Player_Id = bo.Player_Id
JOIN Player p
    ON p.Player_Id = ba.Player_Id
WHERE ba.Avg_Runs >
    (SELECT AVG(Avg_Runs) FROM Batting)
AND bo.Avg_Wickets >
    (SELECT AVG(Avg_Wickets) FROM Bowling);
    
    

-- ============================================================================
-- Objective Question 9
-- Create RCB venue record table
-- ============================================================================

DROP TABLE IF EXISTS rcb_record;

CREATE TABLE rcb_record AS
SELECT
    v.Venue_Name,
    SUM(
        CASE
            WHEN m.Match_Winner = 2 THEN 1
            ELSE 0
        END
    ) AS Wins,
    SUM(
        CASE
            WHEN m.Match_Winner != 2
            OR m.Match_Winner IS NULL
            THEN 1
            ELSE 0
        END
    ) AS Losses
FROM Matches m
JOIN Venue v
    ON m.Venue_Id = v.Venue_Id
WHERE m.Team_1 = 2
OR m.Team_2 = 2
GROUP BY v.Venue_Name;

SELECT * FROM rcb_record;



-- ============================================================================
-- Objective Question 10
-- Impact of bowling style on wickets taken
-- ============================================================================

SELECT
    bs.Bowling_skill,
    COUNT(*) AS Total_Wickets
FROM Wicket_Taken w
JOIN Ball_by_Ball b
    ON w.Match_Id = b.Match_Id
    AND w.Over_Id = b.Over_Id
    AND w.Ball_Id = b.Ball_Id
JOIN Player p
    ON b.Bowler = p.Player_Id
JOIN Bowling_Style bs
    ON p.Bowling_skill = bs.Bowling_Id
GROUP BY bs.Bowling_skill
ORDER BY Total_Wickets DESC;



-- ============================================================================
-- Objective Question 11
-- Team performance analysis using window functions
-- ============================================================================

SELECT *,
    CASE
        WHEN Total_Runs >
            LAG(Total_Runs)
            OVER(PARTITION BY Team_Name ORDER BY Season_Year)
        AND Total_Wickets >
            LAG(Total_Wickets)
            OVER(PARTITION BY Team_Name ORDER BY Season_Year)
        THEN 'Better Performance'
        ELSE 'Needs Improvement'
    END AS Performance_Status
FROM Team_Season;



-- ============================================================================
-- Objective Question 12
-- Team win percentage analysis
-- ============================================================================

SELECT
    t.Team_Name,
    COUNT(DISTINCT m.Match_Id) AS Matches_Played,
    SUM(
        CASE
            WHEN m.Match_Winner = t.Team_Id THEN 1
            ELSE 0
        END
    ) AS Wins,
    ROUND(
        (
            SUM(
                CASE
                    WHEN m.Match_Winner = t.Team_Id THEN 1
                    ELSE 0
                END
            ) * 100.0 /
            COUNT(DISTINCT m.Match_Id)
        ),
        2
    ) AS Win_Percentage
FROM Matches m
JOIN Team t
    ON m.Team_1 = t.Team_Id
    OR m.Team_2 = t.Team_Id
GROUP BY t.Team_Name
ORDER BY Win_Percentage DESC;



-- ============================================================================
-- Objective Question 13
-- Rank bowlers venue wise
-- ============================================================================

SELECT *,
    RANK() OVER(
        PARTITION BY Venue_Name
        ORDER BY Avg_Wickets DESC
    ) AS Venue_Rank
FROM Venue_Wickets;



-- ============================================================================
-- Objective Question 14
-- Players scoring more than 300 runs in a season
-- ============================================================================

SELECT
    p.Player_Name,
    s.Season_Year,
    SUM(b.Runs_Scored) AS Season_Runs
FROM Ball_by_Ball b
JOIN Player p
    ON b.Striker = p.Player_Id
JOIN Matches m
    ON b.Match_Id = m.Match_Id
JOIN Season s
    ON m.Season_Id = s.Season_Id
GROUP BY p.Player_Name, s.Season_Year
HAVING SUM(b.Runs_Scored) >= 300
ORDER BY p.Player_Name, s.Season_Year;



-- ============================================================================
-- Objective Question 15
-- Player performance across venues
-- ============================================================================

SELECT
    p.Player_Name,
    v.Venue_Name,
    SUM(b.Runs_Scored) AS Total_Runs,
    ROUND(AVG(b.Runs_Scored),2) AS Avg_Runs
FROM Ball_by_Ball b
JOIN Player p
    ON b.Striker = p.Player_Id
JOIN Matches m
    ON b.Match_Id = m.Match_Id
JOIN Venue v
    ON m.Venue_Id = v.Venue_Id
GROUP BY p.Player_Name, v.Venue_Name
HAVING SUM(b.Runs_Scored) >= 100
ORDER BY Avg_Runs DESC;



-- ============================================================================
-- SUBJECTIVE QUESTIONS
-- ============================================================================



-- ============================================================================
-- Subjective Question 1
-- How does the toss decision affect the result of the match?
-- ============================================================================

SELECT
    td.Toss_Name,
    t.Team_Name AS Toss_Winner,
    tw.Team_Name AS Match_Winner,
    COUNT(*) AS Matches
FROM Matches m
JOIN Toss_Decision td
    ON m.Toss_Decide = td.Toss_Id
JOIN Team t
    ON m.Toss_Winner = t.Team_Id
JOIN Team tw
    ON m.Match_Winner = tw.Team_Id
GROUP BY td.Toss_Name, Toss_Winner, Match_Winner
ORDER BY Matches DESC;




-- ============================================================================
-- Subjective Question 2
-- Suggest some of the players who would be best fit for the team.
-- ============================================================================

SELECT
    p.Player_Name,
    SUM(b.Runs_Scored) AS Total_Runs,
    ROUND(AVG(b.Runs_Scored),2) AS Avg_Runs,
    ROUND((SUM(b.Runs_Scored)*100.0)/COUNT(*),2) AS Strike_Rate
FROM Ball_by_Ball b
JOIN Player p
    ON b.Striker = p.Player_Id
GROUP BY p.Player_Name
HAVING SUM(b.Runs_Scored) > 500
ORDER BY Strike_Rate DESC;



-- ============================================================================
-- Subjective Question 3
-- Parameters to focus on while selecting players
-- ============================================================================

SELECT
    p.Player_Name,
    ROUND(AVG(b.Runs_Scored),2) AS Avg_Runs,
    COUNT(w.Player_Out) AS Wickets
FROM Player p
LEFT JOIN Ball_by_Ball b
    ON p.Player_Id = b.Striker
LEFT JOIN Wicket_Taken w
    ON p.Player_Id = w.Player_Out
GROUP BY p.Player_Name;



-- ============================================================================
-- Subjective Question 4
-- Players offering versatility in batting and bowling
-- ============================================================================

WITH Batting AS (
    SELECT
        Striker AS Player_Id,
        ROUND(AVG(Runs_Scored),2) AS Avg_Runs
    FROM Ball_by_Ball
    GROUP BY Striker
),

Bowling AS (
    SELECT
        b.Bowler AS Player_Id,
        ROUND(
            COUNT(*) * 1.0 / COUNT(DISTINCT w.Match_Id),
            2
        ) AS Avg_Wickets
    FROM Ball_by_Ball b
    JOIN Wicket_Taken w
        ON b.Match_Id = w.Match_Id
        AND b.Over_Id = w.Over_Id
        AND b.Ball_Id = w.Ball_Id
    GROUP BY b.Bowler
)

SELECT
    p.Player_Name,
    ba.Avg_Runs,
    bo.Avg_Wickets
FROM Batting ba
JOIN Bowling bo
    ON ba.Player_Id = bo.Player_Id
JOIN Player p
    ON p.Player_Id = ba.Player_Id
WHERE ba.Avg_Runs > 1
AND bo.Avg_Wickets > 1
ORDER BY ba.Avg_Runs DESC;



-- ============================================================================
-- Subjective Question 5
-- Players influencing morale and team performance
-- ============================================================================



WITH Batting_Stats AS (
    SELECT
        b.Striker AS Player_Id,
        SUM(b.Runs_Scored) AS Total_Runs,
        ROUND(
            (SUM(b.Runs_Scored) * 100.0) / COUNT(*),
            2
        ) AS Strike_Rate
    FROM Ball_by_Ball b
    GROUP BY b.Striker
),

Bowling_Stats AS (
    SELECT
        b.Bowler AS Player_Id,
        COUNT(*) AS Total_Wickets
    FROM Ball_by_Ball b
    JOIN Wicket_Taken w
        ON b.Match_Id = w.Match_Id
        AND b.Over_Id = w.Over_Id
        AND b.Ball_Id = w.Ball_Id
    GROUP BY b.Bowler
)

SELECT
    p.Player_Name,
    COALESCE(bt.Total_Runs,0) AS Total_Runs,
    COALESCE(bt.Strike_Rate,0) AS Strike_Rate,
    COALESCE(bw.Total_Wickets,0) AS Total_Wickets
FROM Player p
LEFT JOIN Batting_Stats bt
    ON p.Player_Id = bt.Player_Id
LEFT JOIN Bowling_Stats bw
    ON p.Player_Id = bw.Player_Id
WHERE
    COALESCE(bt.Total_Runs,0) > 500
    OR COALESCE(bw.Total_Wickets,0) > 20
ORDER BY Total_Runs DESC;



-- ============================================================================
-- Subjective Question 6
-- Suggestions for RCB before mega auction
-- ============================================================================

SELECT
    s.Season_Year,
    ROUND(
        (
            SUM(
                CASE
                    WHEN m.Match_Winner = 2 THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(*),
        2
    ) AS Win_Percentage
FROM Matches m
JOIN Season s
    ON m.Season_Id = s.Season_Id
WHERE m.Team_1 = 2
OR m.Team_2 = 2
GROUP BY s.Season_Year
ORDER BY s.Season_Year;



-- ============================================================================
-- Subjective Question 7
-- Factors contributing to high-scoring matches
-- ============================================================================

SELECT
    v.Venue_Name,
    SUM(b.Runs_Scored) AS Total_Runs
FROM Ball_by_Ball b
JOIN Matches m
    ON b.Match_Id = m.Match_Id
JOIN Venue v
    ON m.Venue_Id = v.Venue_Id
GROUP BY v.Venue_Name
ORDER BY Total_Runs DESC;



-- ============================================================================
-- Subjective Question 8
-- Impact of home-ground advantage
-- ============================================================================

SELECT
    v.Venue_Name,
    COUNT(*) AS Matches_Played,
    SUM(CASE WHEN m.Match_Winner = 2 THEN 1 ELSE 0 END) AS Wins,
    SUM(CASE WHEN m.Match_Winner != 2 THEN 1 ELSE 0 END) AS Losses
FROM Matches m
JOIN Venue v
    ON m.Venue_Id = v.Venue_Id
WHERE m.Team_1 = 2
OR m.Team_2 = 2
GROUP BY v.Venue_Name
ORDER BY Wins DESC;



-- ============================================================================
-- Subjective Question 9
-- RCB performance and trophy failure analysis
-- ============================================================================

SELECT
    s.Season_Year,
    ROUND(
        (SUM(CASE WHEN m.Match_Winner = 2 THEN 1 ELSE 0 END) * 100.0)
        / COUNT(*),
        2
    ) AS Win_Percentage
FROM Matches m
JOIN Season s
    ON m.Season_Id = s.Season_Id
WHERE m.Team_1 = 2
OR m.Team_2 = 2
GROUP BY s.Season_Year
ORDER BY s.Season_Year;



-- ============================================================================
-- Subjective Question 10
-- Approach if questions were not given
-- ============================================================================

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'ipl';

SELECT
    Season_Id,
    COUNT(*) AS Total_Matches
FROM Matches
GROUP BY Season_Id;

SELECT
    p.Player_Name,
    SUM(b.Runs_Scored) AS Total_Runs
FROM Ball_by_Ball b
JOIN Player p
    ON b.Striker = p.Player_Id
GROUP BY p.Player_Name
ORDER BY Total_Runs DESC;

SELECT
    v.Venue_Name,
    SUM(b.Runs_Scored) AS Total_Runs
FROM Ball_by_Ball b
JOIN Matches m
    ON b.Match_Id = m.Match_Id
JOIN Venue v
    ON m.Venue_Id = v.Venue_Id
GROUP BY v.Venue_Name
ORDER BY Total_Runs DESC;

SELECT
    td.Toss_Name,
    COUNT(*) AS Total_Matches
FROM Matches m
JOIN Toss_Decision td
    ON m.Toss_Decide = td.Toss_Id
GROUP BY td.Toss_Name;





-- ============================================================================
-- Subjective Question 11
-- Delhi Capitals / Delhi Daredevils issue
-- ============================================================================

DESC Matches;

SELECT *
FROM Team
WHERE Team_Name LIKE '%Delhi%';