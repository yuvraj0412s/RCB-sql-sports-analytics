-- Player Performance Analysis
-- Identifies top run-scorers and boundary hitters across seasons.

SELECT 
    p.Player_Name,
    SUM(b.Runs_Scored) AS Total_Runs,
    COUNT(CASE WHEN b.Runs_Scored = 4 THEN 1 END) AS Fours,
    COUNT(CASE WHEN b.Runs_Scored = 6 THEN 1 END) AS Sixes
FROM Ball_by_Ball b
JOIN Player p ON b.Striker = p.Player_Id
GROUP BY p.Player_Name
ORDER BY Total_Runs DESC
LIMIT 10;
