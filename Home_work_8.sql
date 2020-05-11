USE vk_db;


-- creating queries

-- 3. Calculate the total number of likes for the ten youngest users (how many likes the 10 youngest users received).
SELECT p.user_id, CONCAT(u.first_name, " ", u.last_name) AS "user_name", p.birthday, COUNT(*) AS "total_likes"
 FROM profiles p 
  JOIN users u 
   ON p.user_id = u.id 
    JOIN likes l 
     ON p.user_id = l.target_id
      JOIN target_types tt 
       ON l.target_type_id = tt.id 
 WHERE target_types = "users"
  GROUP BY p.user_id
   ORDER BY birthday DESC
    LIMIT 10;


-- 4. Determine who put the most likes (total) - men or women?
SELECT p.gender, COUNT(*) AS "total_likes"
 FROM likes l 
  JOIN profiles p 
   ON l.user_id = p.user_id 
 GROUP BY p.gender 
  ORDER BY total_likes DESC 
   LIMIT 1;
-- men put more likes

 
-- 5. Find 10 users who are least active in using social network (activity criteria must be determined independently).
--     first criteria updated_at profile number of days
--     second criteria updated_at user number of days
--     third criteria count of likes
--     fourth criteria count of posts
--     fifth criteria conunt of friends
--     all criterias normalized by the log function 
--     sum of normalized criterias give the estimation score, the higher the score the more activities is produced by user

-- updating update_at in profiles
UPDATE profiles SET updated_at = MAKEDATE(2020, FLOOR(1 + RAND() * 365));
UPDATE profiles SET updated_at = CURRENT_DATE() WHERE updated_at > CURRENT_DATE();

-- query for 10 users with minimum activities in social network
SELECT u.id, 
       CONCAT(u.first_name, " ", u.last_name) AS user_name,
       (IF(LOG(DATEDIFF(CURRENT_DATE(), u.updated_at)) IS NULL, 0, LOG(DATEDIFF(CURRENT_DATE(), u.updated_at))) +
        IF(LOG(DATEDIFF(CURRENT_DATE(), p.updated_at)) IS NULL, 0, LOG(DATEDIFF(CURRENT_DATE(), p.updated_at))) +
        IF(LOG(tl.total_likes) IS NULL, 0, LOG(tl.total_likes)) +
        IF(LOG(tp.total_posts) IS NULL, 0, LOG(tp.total_posts)) +
        IF(LOG(tf.total_friends) IS NULL, 0, LOG(tf.total_friends))
       ) AS estimation_score
 FROM users u
  JOIN profiles p 
   ON u.id = p.user_id
    JOIN (SELECT l.target_id, COUNT(*) as "total_likes" 
           FROM likes l 
            JOIN target_types tt 
             ON l.target_type_id = tt.id 
              WHERE target_types = "users" 
               GROUP BY l.target_id
          ) tl 
    ON u.id = tl.target_id
     JOIN (SELECT user_id, COUNT(*) AS total_posts 
            FROM posts 
             GROUP BY user_id
           ) tp 
      ON u.id = tp.user_id
       JOIN 
        (SELECT user_id, (friends_1 + friends_2) AS total_friends 
         FROM
          (SELECT user_id, COUNT(*) AS friends_1 
            FROM friendship f 
             JOIN friendship_statuses fs 
              ON f.status_id = fs.id 
               WHERE fs.name = "confirmed"
                GROUP BY user_id) AS fs_table_1
         JOIN  
          (SELECT friend_id, COUNT(*) AS friends_2
           FROM friendship f 
            JOIN friendship_statuses fs 
             ON f.status_id = fs.id 
              WHERE fs.name = "confirmed"
               GROUP BY friend_id) AS fs_table_2
         ON fs_table_1.user_id = fs_table_2.friend_id) AS tf
       ON  u.id = tf.user_id
 ORDER BY estimation_score
  LIMIT 10; 
  



       
-- help 
-- developing query of total friends
SELECT user_id, (friends_1 + friends_2) AS total_friends FROM
 (SELECT user_id, COUNT(*) AS friends_1 
   FROM friendship f 
    JOIN friendship_statuses fs 
     ON f.status_id = fs.id 
      WHERE fs.name = "confirmed"
       GROUP BY user_id) AS fs_table_1
 JOIN  
  (SELECT friend_id, COUNT(*) AS friends_2
    FROM friendship f 
     JOIN friendship_statuses fs 
      ON f.status_id = fs.id 
       WHERE fs.name = "confirmed"
        GROUP BY friend_id) AS fs_table_2
 ON fs_table_1.user_id = fs_table_2.friend_id;  