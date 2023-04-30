USE `vk`;
-- 1. Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW] (вывести друзей друзей пользователя с id=1)
CREATE VIEW `friends_of_friends` AS
SELECT `id`, `firstname`, `lastname`
FROM `users`
WHERE `ID` IN
      (SELECT DISTINCT `target_user_id`
       FROM `friend_requests`
       WHERE `initiator_user_id` IN
             (SELECT `target_user_id`
              FROM `friend_requests`
              WHERE `initiator_user_id` = 1
              UNION ALL
              SELECT `initiator_user_id`
              FROM `friend_requests`
              WHERE `target_user_id` = 1)
       UNION ALL
       SELECT DISTINCT `initiator_user_id`
       FROM `friend_requests`
       WHERE `target_user_id` IN
             (SELECT `target_user_id`
              FROM `friend_requests`
              WHERE `initiator_user_id` = 1
              UNION ALL
              SELECT `initiator_user_id`
              FROM `friend_requests`
              WHERE `target_user_id` = 1));

-- 2. Выведите данные, используя написанное представление [SELECT]
SELECT * FROM `friends_of_friends` ORDER BY `id`;

-- 3. Удалите представление [DROP VIEW]
DROP VIEW `friends_of_friends`;

-- 4. * Сколько новостей (записей в таблице media) у каждого пользователя? Вывести поля: news_count (количество новостей),
-- user_id (номер пользователя), user_email (email пользователя). Попробовать решить с помощью CTE или с помощью обычного JOIN.
SELECT DISTINCT u.`id`                                      AS `user_id`,
                u.`email`                                   AS `user_email`,
                SUM(m.`id`) OVER (PARTITION BY m.`user_id`) AS `news_count`
FROM `users` AS u
      LEFT OUTER JOIN `media` AS m on u.`id` = m.`user_id`
ORDER BY `news_count` DESC;

SELECT u.`id`                                                                       AS `user_id`,
       u.`email`                                                                    AS `user_email`,
       IFNULL((SELECT SUM(m.`id`) FROM `media` AS m WHERE m.`user_id` = u.`id`), 0) AS news_count
FROM `users` AS u
ORDER BY `news_count` DESC;