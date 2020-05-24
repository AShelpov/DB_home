USE vk_db;


-- Build a query that will output the following columns:
--   group name
--   average number of users in groups
--   the youngest user in the group
--   oldest user in the group
--   total number of users in groups
--   total users in the system
--   ratio in percent (total number of users in the group / total users in the system) * 100

SELECT DISTINCT comm.id, comm.name, 
  COUNT(comm_use.user_id) OVER() / (SELECT COUNT(*) FROM communities) AS average_number_of_users_in_groups,
  MAX(p.birthday) OVER(PARTITION BY comm.id) AS the_youngest_user_in_the_group,
  MIN(p.birthday) OVER(PARTITION BY comm.id) AS the_oldest_user_in_the_group,
  COUNT(comm_use.user_id) OVER(PARTITION BY comm.id) AS total_number_of_users_in_the_group,
  (SELECT COUNT(*) FROM profiles) AS total_users_in_the_system,
  COUNT(comm_use.user_id) OVER(PARTITION BY comm.id) / (SELECT COUNT(*) FROM profiles) AS ratio_percent
    FROM communities comm 
      LEFT JOIN communities_users comm_use 
        ON comm.id = comm_use.community_id
      LEFT JOIN profiles p 
        ON comm_use.user_id = p.user_id;

       
-- Analyze what queries can be performed most often during the application and add the necessary indexes.

-- basicly database will be used to search people according to certain criteria, therefore columns with such criterias will be used mainly
CREATE INDEX users_first_name_idx ON users(first_name);
CREATE INDEX users_last_name_idx ON users(last_name);
CREATE UNIQUE INDEX users_email_idx ON users(email);
CREATE UNIQUE INDEX users_phone_idx ON users(phone);
CREATE INDEX profiles_city_idx ON profiles(city);
CREATE INDEX profiles_country_idx ON profiles(country);

