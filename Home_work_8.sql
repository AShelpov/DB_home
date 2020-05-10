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
--     first criteria updated_at profile max num of days
--     second criteria updated_at user max num of days
--     third criteria min of likes
--     fourth criteria min posts
--     fifth criteria min friends
SELECT id,
       (CONCAT(first_name, " ", last_name)) AS "user name",
       (SELECT DATEDIFF(CURRENT_DATE(), updated_at) FROM profiles WHERE profiles.user_id = users.id) AS "first_criteria",
       (DATEDIFF(CURRENT_DATE(), updated_at)) AS "second_criteria",
       (SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id ) AS "third_criteria",
       (SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id) AS "fourth_criteria",
       ((SELECT COUNT(*) FROM friendship WHERE friendship.user_id = users.id AND friendship.status_id = 
           (SELECT id FROM friendship_statuses WHERE name = "confirmed")) +
       (SELECT COUNT(*) FROM friendship WHERE friendship.friend_id = users.id AND friendship.status_id = 
           (SELECT id FROM friendship_statuses WHERE name = "confirmed"))
        ) AS "fifth_criteria"
  FROM users 
    ORDER BY first_criteria DESC, second_criteria DESC,
    third_criteria, fourth_criteria, fifth_criteria
  LIMIT 10; 
 
