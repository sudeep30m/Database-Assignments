
-- 1 --
SELECT player_name FROM player 
WHERE country_name = 'England' AND batting_hand = 'Left-hand bat' 
ORDER BY player_name;

-- 2 --
SELECT player_name, date_part('year',age(dob)) AS player_age 
FROM player 
WHERE bowling_skill = 'Legbreak googly' AND date_part('year',age(dob)) >= 28 
ORDER BY date_part('year',age(dob)) DESC, player_name;

-- 3 --
SELECT match_id, toss_winner FROM match 
WHERE toss_decision = 'bat' 
ORDER BY match_id; 

-- 4 --
SELECT over_id, sum(runs_scored) AS runs_scored 
FROM ( (SELECT match_id, over_id, ball_id, extra_runs AS runs_scored, innings_no FROM extra_runs) UNION ALL (SELECT * FROM batsman_scored) ) as extras
WHERE match_id = 335987 
GROUP BY (over_id, innings_no) 
HAVING sum(runs_scored) <= 7
ORDER BY sum(runs_scored) DESC, over_id;   


-- 5 --
SELECT DISTINCT player.player_name 
FROM wicket_taken, player 
where wicket_taken.player_out = player.player_id AND kind_out = 'bowled' 
ORDER BY player.player_name ASC;

-- 6 --
WITH results AS (
SELECT match_id, team_1, team_2, match_winner, win_margin 
FROM match
WHERE win_type = 'runs' AND win_margin >= 60
) 
SELECT match_id, t1.name as team_1, t2.name AS team_2, t3.name AS winning_team_name, win_margin 
FROM ((results JOIN team t1 ON (team_1 = t1.team_id) ) JOIN team t2 ON (team_2 = t2.team_id)) JOIN team t3 ON (match_winner = t3.team_id)
ORDER BY win_margin, match_id;

-- 7 --
SELECT player_name FROM player 
WHERE date_part('year', age('2018-02-12',dob)) < 30 AND batting_hand = 'Left-hand bat' 
ORDER BY player_name;

-- 8 --
SELECT match_id , SUM(runs) AS total_runs
FROM (SELECT match_id, runs_scored AS runs
     FROM batsman_scored
     UNION ALL
     SELECT match_id, extra_runs AS runs
     FROM extra_runs) AS match_run
GROUP BY match_id 
ORDER BY match_id; 

-- 9 --
WITH runs_per_over AS (    
    SELECT match_id, over_id, innings_no, sum(runs_scored) as runs
    FROM ( (SELECT match_id, over_id, ball_id, extra_runs AS runs_scored, innings_no FROM extra_runs) UNION ALL (SELECT * FROM batsman_scored) ) as extras
    GROUP BY (match_id, over_id,innings_no)  
), maximum_runs AS (
    SELECT match_id, max(runs) AS runs
    FROM runs_per_over
    GROUP BY match_id
), maximum_runs_over_id AS(
    SELECT match_id, over_id, innings_no,runs 
    FROM runs_per_over NATURAL JOIN maximum_runs
), match_id_bowler AS (
    SELECT DISTINCT match_id, over_id, innings_no, bowler as player_id, runs
    FROM ball_by_ball NATURAL JOIN maximum_runs_over_id 
    ORDER BY match_id,over_id, innings_no
) 
SELECT match_id, runs as maximum_runs, player_name
FROM match_id_bowler NATURAL JOIN player 
ORDER BY match_id, over_id;

-- 10 --
WITH run_outs as (SELECT *
                    FROM wicket_taken
                    WHERE kind_out = 'run out')
SELECT player_name , COUNT(player_out) AS number
FROM player p LEFT OUTER JOIN run_outs r_o ON  p.player_id = r_o.player_out
GROUP BY player_name
ORDER BY COUNT(player_out) DESC, player_name; 

-- 11 --
SELECT kind_out as out_type, count(match_id) as number 
FROM wicket_taken 
GROUP BY kind_out
ORDER BY count(match_id) DESC, out_type;

-- 12 --
SELECT name, COUNT(name) AS number
FROM match m LEFT OUTER JOIN ( player_match NATURAL JOIN team) x ON m.man_of_the_match = x.player_id AND m.match_id = x.match_id
GROUP BY name 
ORDER BY name;

-- 13 --
WITH wides_per_match AS (
    SELECT match_id, count(extra_type) AS wides 
    FROM extra_runs
    WHERE extra_type = 'wides'
    GROUP BY match_id
)
    SELECT venue
    FROM wides_per_match NATURAL JOIN match
    GROUP BY venue 
    ORDER BY sum(wides) DESC, venue 
    LIMIT 1; 

-- 14 --
SELECT venue
FROM match
WHERE (toss_winner = match_winner AND toss_decision = 'field') OR (toss_winner <> match_winner AND toss_decision = 'bat')
GROUP BY venue
ORDER BY COUNT(venue) DESC , venue;

-- 15 --
WITH bowlers_wicket AS (
    SELECT *    
    FROM wicket_taken NATURAL JOIN ball_by_ball
    WHERE kind_out = 'caught' OR
        kind_out = 'bowled' OR 
        kind_out = 'caught and bowled' OR
        kind_out = 'stumped' OR
        kind_out = 'lbw' OR
        kind_out = 'hit wicket'
), wickets_per_bowler AS (
    SELECT bowler, count(kind_out) as wickets 
    FROM bowlers_wicket NATURAL JOIN ball_by_ball 
    GROUP BY bowler
), runs_per_bowler AS (
    SELECT bowler, sum(runs_scored) as runs
    FROM batsman_scored NATURAL JOIN ball_by_ball 
    GROUP BY bowler
), bowler_stats AS (
    SELECT player_name, wickets, runs, ROUND((runs::float / wickets)::decimal,3) AS average  
    FROM 
    player JOIN (wickets_per_bowler NATURAL JOIN runs_per_bowler)   
    ON bowler = player_id 
    ORDER BY average
) SELECT player_name 
FROM bowler_stats
WHERE average = (SELECT min(average) FROM bowler_stats);

-- 16 --
WITH cap_keep AS (SELECT * 
                  FROM player_match NATURAL JOIN player
                  WHERE role ='CaptainKeeper')          
SELECT player_name, name
FROM (cap_keep NATURAL JOIN team) NATURAL JOIN match
WHERE team_id = match_winner

ORDER BY player_name, name;

-- 17 --
WITH batsman_stats as (
    SELECT match_id, over_id, ball_id, innings_no, runs_scored, striker as batsman
    FROM ball_by_ball NATURAL JOIN batsman_scored
), batsman_above_50 as (
    SELECT batsman
    FROM batsman_stats 
    GROUP BY (batsman, match_id)
    HAVING sum(runs_scored) >= 50 
),total_runs AS (
    SELECT batsman AS player_id, sum(runs_scored) AS runs_scored FROM batsman_stats 
    WHERE batsman IN (SELECT * FROM batsman_above_50)
    GROUP BY batsman 
) SELECT player_name, runs_scored
   FROM total_runs NATURAL JOIN player
   ORDER BY runs_scored DESC,player_name;

-- 18 --
WITH ball_by_ball_2 AS (SELECT *
                        FROM ball_by_ball LEFT OUTER JOIN player ON striker = player_id)
SELECT  player_name
FROM (ball_by_ball_2 NATURAL JOIN batsman_scored) NATURAL JOIN match 
WHERE team_batting <> match_winner  -- much faster grouping now!
GROUP BY match_id, striker, player_name
HAVING SUM(runs_scored) >= 100
ORDER BY player_name;

-- 19 --
SELECT match_id, venue  FROM match 
WHERE (team_1 = 1 OR team_2 = 1) AND match_winner != 1
ORDER BY match_id;

-- 20 --
WITH score_per_match AS (
                SELECT striker , match_id , SUM(runs_scored) AS runs_match
                FROM batsman_scored NATURAL JOIN ball_by_ball
                GROUP BY striker , match_id)
SELECT player_name
FROM (score_per_match spm LEFT OUTER JOIN player p ON spm.striker = p.player_id ) NATURAL JOIN match
WHERE season_id = 5
GROUP BY striker , player_name
ORDER BY round ((SUM(runs_match) / COUNT(match_id) ),3) DESC , player_name
LIMIT 10;

-- 21 --
WITH score_per_match AS (
                SELECT striker , match_id , SUM(runs_scored) AS runs_match
                FROM batsman_scored NATURAL JOIN ball_by_ball
                GROUP BY striker , match_id),
     batting_avg AS (
                SELECT striker , (SUM(runs_match) /COUNT(match_id)) AS batting_avg_value
                FROM score_per_match
                GROUP BY striker),
     country_avg_tot AS (
        SELECT country_name, round( SUM( coalesce(batting_avg_value, 0) ) / COUNT(player_name) ,3 ) AS country_batting_avg
        FROM player p LEFT OUTER JOIN batting_avg b_a ON b_a.striker = p.player_id
        GROUP BY country_name
        ORDER BY country_batting_avg DESC , country_name),
     top_five_avg AS (
        SELECT DISTINCT country_batting_avg as top_averages
        FROM  country_avg_tot
        ORDER BY country_batting_avg DESC
        LIMIT 5)
SELECT country_name 
FROM country_avg_tot
WHERE country_batting_avg >= (SELECT MIN(top_averages) FROM top_five_avg)
ORDER BY country_batting_avg DESC;
