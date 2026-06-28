-- Venue Analysis
-- Evaluates which venues favor chasing vs defending

SELECT 
    v.Venue_Name,
    COUNT(m.Match_Id) AS Total_Matches,
    SUM(CASE WHEN m.Toss_Decision = 'field' AND m.Match_Winner = m.Toss_Winner THEN 1 ELSE 0 END) AS Wins_Chasing,
    SUM(CASE WHEN m.Toss_Decision = 'bat' AND m.Match_Winner = m.Toss_Winner THEN 1 ELSE 0 END) AS Wins_Defending
FROM Matches m
JOIN Venue v ON m.Venue_Id = v.Venue_Id
GROUP BY v.Venue_Name
ORDER BY Total_Matches DESC;
