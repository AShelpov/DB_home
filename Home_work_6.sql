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


-- create queries

-- 3. ���������� ����� ���������� ������ ������ ����� ������� ������������� 
-- (������� ������ �������� 10 ����� ������� �������������).



