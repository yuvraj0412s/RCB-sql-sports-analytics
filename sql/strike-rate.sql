-- Strike Rate Analysis
-- Calculates the strike rate of top batsmen to identify elite finishers

SELECT 
    p.Player_Name,
    SUM(b.Runs_Scored) AS Total_Runs,
    COUNT(b.Ball_Id) AS Balls_Faced,
    ROUND((SUM(b.Runs_Scored) * 100.0) / COUNT(b.Ball_Id), 2) AS Strike_Rate
FROM Ball_by_Ball b
JOIN Player p ON b.Striker = p.Player_Id
WHERE b.Extra_Type NOT IN ('wides', 'noballs') -- exclude extras from balls faced
GROUP BY p.Player_Name
HAVING Balls_Faced > 200 -- filter for meaningful sample size
ORDER BY Strike_Rate DESC
LIMIT 15;
