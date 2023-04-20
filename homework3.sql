USE `vk`;
-- 1. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY]
SELECT DISTINCT `firstname`
FROM `users`
ORDER BY `firstname`;

-- 2. Выведите количество мужчин старше 35 лет [COUNT].
SELECT COUNT(`user_id`)
FROM `profiles`
WHERE TIMESTAMPDIFF(YEAR, `birthday`, CURDATE()) > 35
  AND `gender` = 'm'; -- 15

-- 3. Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]
SELECT `status`, COUNT(`status`) AS `request_count`
FROM `friend_requests`
GROUP BY `status`
ORDER BY `status`; -- 16, 19, 11, 11

-- 4. * Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT].

SELECT `initiator_user_id` -- так будет быстрее
FROM `friend_requests`
GROUP BY `initiator_user_id`
ORDER BY COUNT(`initiator_user_id`) DESC
LIMIT 1; -- 1

SELECT t.`initiator_user_id` -- так будет корректнее, вдруг "победителей" несколько
FROM (SELECT `initiator_user_id`, COUNT(`initiator_user_id`) AS `cnt`
      FROM `friend_requests`
      GROUP BY `initiator_user_id`) AS t
WHERE t.`cnt` =
      (SELECT MAX(t.`cnt`)
       FROM (SELECT `initiator_user_id`, COUNT(`initiator_user_id`) AS `cnt`
             FROM `friend_requests`
             GROUP BY `initiator_user_id`) AS t); -- 1

-- 5. * Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE].
SELECT `id`, `name`
FROM `communities`
WHERE CHAR_LENGTH(`name`) = 5
ORDER BY `id`; -- 2, 4

SELECT `id`, `name`
FROM `communities`
WHERE `name` LIKE '_____'
ORDER BY `id`; -- 2, 4