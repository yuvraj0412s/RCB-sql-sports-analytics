-- Toss Decision Analysis
-- Analyzes the impact of toss decisions on match outcomes

SELECT 
    Toss_Decision,
    COUNT(Match_Id) AS Total_Decisions,
    SUM(CASE WHEN Toss_Winner = Match_Winner THEN 1 ELSE 0 END) AS Matches_Won,
    ROUND((SUM(CASE WHEN Toss_Winner = Match_Winner THEN 1 ELSE 0 END) * 100.0) / COUNT(Match_Id), 2) AS Win_Percentage
FROM Matches
GROUP BY Toss_Decision;
