USE `vk`;
-- 1. Подсчитать количество групп, в которые вступил каждый пользователь.
SELECT u.`id` AS `user_id`, u.`lastname`, u.`firstname`, COUNT(uc.`community_id`) AS `communities_count`
FROM `users` AS u
         LEFT OUTER JOIN `users_communities` AS uc
                         ON u.`id` = uc.`user_id`
GROUP BY u.`id`, u.`lastname`, u.`firstname`
-- ORDER BY `communities_count`;
ORDER BY u.`lastname`, u.`firstname`, u.`id`; -- трое без группы, один в 2х, один в 3х, у остальных по 1

-- 2. Подсчитать количество пользователей в каждом сообществе.
SELECT c.`id` AS `community_id`, c.`name`, COUNT(uc.`user_id`) AS `users_count`
FROM `communities` AS c
         LEFT OUTER JOIN `users_communities` AS uc
             ON c.`id` = uc.`community_id`
GROUP BY c.`id`, c.`name`
ORDER BY c.`name`, c.`id`; -- ровно по 10 в каждом

-- 3. Пусть задан некоторый пользователь. Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем (написал ему сообщений).

SELECT m.`from_user_id` AS `user_id`, u.lastname, u.firstname, COUNT(m.`id`) AS `messages_count`
FROM `messages` AS m
    LEFT OUTER JOIN `users` AS u ON m.`from_user_id` = u.`id`
WHERE m.`to_user_id`=:user
GROUP BY m.`from_user_id`
ORDER BY `messages_count` DESC, m.`from_user_id`  LIMIT 1;

-- * 4. Подсчитать общее количество лайков, которые получили пользователи младше 18 лет..
SELECT COUNT(l.id) AS `likes_count_for_children`
FROM `profiles` AS p,
     `likes` AS l
WHERE p.`user_id` = l.user_id
  AND TIMESTAMPDIFF(YEAR, p.`birthday`, CURDATE()) < 18; -- 2

-- * 5. Определить, кто больше поставил лайков (всего): мужчины или женщины.
SELECT IF(tt.`male` > tt.`female`, 'male', 'female') AS `answer`, GREATEST(`female`, `male`) AS `likes_count`
FROM (SELECT GROUP_CONCAT(IF(t.`gender` = 'f', t.`likes_count`, NULL)) + 0 AS `female`,
             GROUP_CONCAT(IF(t.`gender` = 'm', t.`likes_count`, NULL)) + 0 AS `male`
      FROM (SELECT p.`gender`, COUNT(l.`id`) AS `likes_count`
            FROM `profiles` AS p,
                 `likes` AS l
            WHERE p.`user_id` = l.user_id
            GROUP BY p.`gender`) AS t) AS tt; -- female,10
