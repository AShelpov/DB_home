USE vk_db;
SHOW TABLES;
DESC likes;

-- update table of likes
SELECT * FROM likes LIMIT 10;
ALTER TABLE list_of_likes RENAME likes;
ALTER TABLE likes RENAME COLUMN who_like_id TO user_id;
ALTER TABLE likes RENAME COLUMN type_of_content TO target_type_id;
ALTER TABLE likes RENAME  COLUMN id_of_content TO target_id;
ALTER TABLE likes target_id AFTER user_id;
ALTER TABLE likes ADD COLUMN created_at DATETIME AFTER target_id;

UPDATE likes SET created_at = 
    MAKEDATE(
    FLOOR(2015 + RAND() * 6),
    FLOOR(1 + RAND()* 364)
    );
    
SELECT COUNT(*) FROM likes WHERE created_at > CURRENT_DATE(); 
UPDATE likes SET created_at = CURRENT_DATE() WHERE created_at > CURRENT_DATE();


-- update list_of_content
SELECT * FROM target_types;
ALTER TABLE list_of_content RENAME target_types;
ALTER TABLE target_types RENAME COLUMN group_of_content TO target_types;
ALTER TABLE target_types ADD COLUMN created_at DATETIME AFTER target_types;
UPDATE target_types SET created_at = DATE('2015-01-01');


-- create table of posts
DROP TABLE IF EXISTS posts;
CREATE TABLE posts(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNSIGNED NOT NULL,
    post_body VARCHAR(1000),
    media_type_attached  INT UNSIGNED,
    id_media_attached INT UNSIGNED,
    community_id INT UNSIGNED,
    created_at DATETIME NOT NULL);
-- fill table from filldb
-- update data in posts table 
SELECT * FROM posts LIMIT 10;

UPDATE posts SET media_type_attached = IF(FLOOR(1 + RAND() * 2) = 1, 0, media_type_attached);
UPDATE posts SET media_type_attached = NULL WHERE media_type_attached = 0;
UPDATE posts SET id_media_attached = NULL WHERE media_type_attached IS NULL;
UPDATE posts SET community_id = IF(FLOOR(1 + RAND() * 2) = 1, 0, community_id);
UPDATE posts SET community_id = NULL WHERE community_id = 0;
UPDATE posts SET created_at = 
    MAKEDATE(
    FLOOR(2015 + RAND() * 6),
    FLOOR(1 + RAND()* 364)
    );
SELECT COUNT(*) FROM posts WHERE created_at > CURRENT_DATE();   
UPDATE posts SET created_at = CURRENT_DATE() WHERE created_at > CURRENT_DATE();

UPDATE posts SET id_media_attached = 
   IF((SELECT id FROM media WHERE media.user_id = posts.user_id AND media.media_type_id = posts.media_type_attached ORDER BY RAND() LIMIT 1) IS NULL,
   NULL,
  (SELECT id FROM media WHERE media.user_id = posts.user_id AND media.media_type_id = posts.media_type_attached ORDER BY RAND() LIMIT 1));

SELECT * FROM posts WHERE media_type_attached IS NOT NULL AND id_media_attached IS NULL;
UPDATE posts SET media_type_attached = NULL WHERE id_media_attached IS NULL;


UPDATE posts SET community_id = 
    (SELECT community_id FROM communities_users WHERE communities_users.user_id = posts.user_id ORDER BY RAND() LIMIT 1);
SELECT COUNT(*) FROM posts WHERE community_id IS NOT NULL;
UPDATE posts SET community_id = IF(FLOOR(1 + RAND() * 2) = 1, NULL, community_id);


-- create foreign keys
ALTER TABLE profiles 
  ADD CONSTRAINT profiles_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id);

ALTER TABLE media
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT media_media_type_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id);
   
ALTER TABLE communities_users 
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT communities_users_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id);

ALTER TABLE friendship 
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT frienship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

ALTER TABLE likes 
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT likes_target_type_id
    FOREIGN KEY (target_type_id) REFERENCES target_types(id);

ALTER TABLE posts 
  ADD CONSTRAINT posts_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT posts_media_type_attached_fk
    FOREIGN KEY (media_type_attached) REFERENCES media_types(id),
  ADD CONSTRAINT posts_id_media_attached_fk
    FOREIGN KEY (id_media_attached) REFERENCES media(id),
  ADD CONSTRAINT posts_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id);

ALTER TABLE messages 
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id);
-- create queries

-- 3. Calculate the total number of likes for the ten youngest users (how many likes the 10 youngest users received).
SELECT COUNT(*) AS "total likes", 
       (SELECT 
         FLOOR(((YEAR(CURRENT_DATE()) - YEAR(birthday)) * 12 + MONTH(CURRENT_DATE()) - MONTH(birthday)) / 12) 
         FROM profiles WHERE likes.target_id = profiles.user_id) AS 'age',
       (SELECT CONCAT(first_name, " ", last_name) FROM users WHERE likes.target_id = users.id) AS "user name",
       target_id AS "user id"
  FROM likes WHERE
  target_type_id = (SELECT id FROM target_types WHERE target_types = 'users')
  GROUP BY target_id ORDER BY age LIMIT 10;
 

