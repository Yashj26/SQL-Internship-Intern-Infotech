#Extract `P_ID`, `Dev_ID`, `PName`, and `Difficulty_level` of all players at Level 0. 
SELECT player_details.P_ID, level_details.Dev_ID, player_details.PName, level_details.Difficulty as Difficulty_level, Level
FROM player_details player_details
JOIN level_details level_details ON player_details.P_ID = level_details.P_ID
WHERE level_details.Level = 0;



#Find the total number of stages crossed at each difficulty level for Level 2 with players.
SELECT 
    difficulty, 
    SUM(stages_crossed) AS total_stages_crossed
FROM 
    Level_Details
WHERE 
    level = 2
GROUP BY 
    difficulty;



#Find `Level1_code`wise average `Kill_Count` where `lives_earned` is 2, and at least 3 
stages are crossed.using `zm_series` devices. Arrange the result in decreasing order of the total number of 
stages crossed. 
SELECT 
    pd.L1_code, 
    AVG(ld.kill_count) AS average_kill_count,
    SUM(ld.stages_crossed) AS total_stages_crossed
FROM 
    Player_Details pd
JOIN 
    Level_Details ld ON pd.P_ID = ld.P_ID
WHERE 
    ld.lives_earned = 2
    AND ld.stages_crossed >= 3
    AND ld.Dev_ID LIKE 'zm_series%'
GROUP BY 
    pd.L1_code
ORDER BY 
    total_stages_crossed DESC;



#Find the `first_login` datetime for each device ID.  
SELECT Dev_ID, MIN(TimeStamp) AS first_login
FROM level_details
GROUP BY Dev_ID;



#Find `P_ID` and levelwise sum of `kill_counts` where `kill_count` is greater than the 
average kill count for Medium difficulty. 
SELECT P_ID, Level, SUM(Kill_Count) as Total_Kill_Count
FROM level_details
WHERE Kill_Count > (
    SELECT AVG(Kill_Count)
    FROM level_details
    WHERE Difficulty = 'Medium'
)
GROUP BY P_ID, Level;



#Find `Level` and its corresponding `Level_code`wise sum of lives earned, excluding Level  
0. Arrange in ascending order of level.  
SELECT ld.Level, pd.L2_Code, SUM(ld.Lives_Earned) as Total_Lives_Earned
FROM level_details ld
JOIN player_details pd ON ld.P_ID = pd.P_ID
WHERE ld.Level > 0
GROUP BY ld.Level, pd.L2_Code
ORDER BY ld.Level ASC;


#Find the top 3 scores based on each `Dev_ID` and rank them in increasing order using 
`Row_Number`. Display the difficulty as well.  
SELECT subquery.Dev_ID, subquery.Difficulty, subquery.Score, subquery.Rn
FROM (
    SELECT ld.Dev_ID, ld.Difficulty, ld.Score,
        ROW_NUMBER() OVER (PARTITION BY ld.Dev_ID ORDER BY ld.Score) as Rn
    FROM level_details ld) AS subquery
WHERE Rn <= 3;


#Find the top 5 scores based on each difficulty level and rank them in increasing order 
using `Rank`. Display `Dev_ID` as well. 
SELECT subquery.Dev_ID, subquery.Difficulty, subquery.Score, subquery.Rn
FROM (
    SELECT ld.Dev_ID, ld.Difficulty, ld.Score,
        RANK() OVER (PARTITION BY ld.Difficulty ORDER BY ld.Score ASC) as Rn
    FROM level_details ld) AS subquery
WHERE Rn <= 5;


#Extract the top 3 highest sums of scores for each `Dev_ID` and the corresponding `P_ID`.    
SELECT Dev_ID, P_ID, SUM(Score) as Total_Score
FROM level_details
GROUP BY Dev_ID, P_ID
ORDER BY Dev_ID, Total_Score DESC
LIMIT 3;

#Find players who scored more than 50% of the average score, scored by the sum of 
scores for each `P_ID`.  
SELECT pd.P_ID, pd.PName, AVG(ld2.Score) as Average_Score
FROM player_details pd
JOIN level_details ld2 ON pd.P_ID = ld2.P_ID
JOIN ( SELECT P_ID, AVG(Score) as Player_Avg_Score
    FROM level_details
    GROUP BY P_ID
) avg_scores ON pd.P_ID = avg_scores.P_ID
WHERE ld2.Score > 0.5 * avg_scores.Player_Avg_Score
GROUP BY pd.P_ID, pd.PName;


