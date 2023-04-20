USE `vk`;
-- 1. Создать БД vk, исполнив скрипт _vk_db_creation.sql (в материалах к уроку)
-- 2. Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)
CREATE TABLE `trash_messages`
(
    `id`           bigint(20) UNSIGNED NOT NULL,
    `from_user_id` bigint(20) UNSIGNED NOT NULL,
    `to_user_id`   bigint(20) UNSIGNED NOT NULL,
    `body`         text,
    `created_at`   datetime                     DEFAULT NULL,
    `deleted_at`   timestamp           NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE = InnoDB;
ALTER TABLE `trash_messages`
    ADD UNIQUE KEY `id` (`id`),
    ADD KEY `from_user_id` (`from_user_id`),
    ADD KEY `to_user_id` (`to_user_id`);
ALTER TABLE `trash_messages`
    MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;
ALTER TABLE `trash_messages`
    ADD CONSTRAINT `trash_messages_ibfk_1` FOREIGN KEY (`from_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
    ADD CONSTRAINT `trash_messages_ibfk_2` FOREIGN KEY (`to_user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
CREATE TRIGGER `message_trash`
    AFTER DELETE
    ON `messages`
    FOR EACH ROW INSERT INTO `trash_messages`(`id`, `from_user_id`, `to_user_id`, `body`, `created_at`)
                 VALUES (OLD.`id`, OLD.`from_user_id`, OLD.`to_user_id`, OLD.`body`, OLD.`created_at`);

CREATE TABLE `relationships`
(
    `user_id`       BIGINT UNSIGNED NOT NULL,
    `other_user_id` BIGINT UNSIGNED NOT NULL,
    `type`          CHAR(1)         NOT NULL
) ENGINE = InnoDB;
ALTER TABLE `relationships` ADD PRIMARY KEY(`user_id`, `other_user_id`);
ALTER TABLE `relationships`
    ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE `relationships`
    ADD FOREIGN KEY (`other_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- 3. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)
INSERT INTO `users` (`firstname`, `lastname`, `email`)
VALUES ('Иван', 'Иванов', 'ivan@example.com'),
       ('1', '11', '111@example.com'),
       ('2', '22', '222@example.com'),
       ('3', '33', '333@example.com'),
       ('4', '44', '444@example.com'),
       ('5', '55', '555@example.com'),
       ('6', '66', '666@example.com'),
       ('7', '77', '777@example.com'),
       ('8', '88', '888@example.com'),
       ('9', '99', '999@example.com'),
       ('Петр', 'Петров', 'petr@example.com');
INSERT INTO `profiles`(`user_id`, `gender`, `birthday`)
VALUES (1, 'm', '1988-08-08'),
       (2, 'f', '2003-12-10'),
       (3, 'f', '2012-12-12'),
       (4, 'f', '2014-04-08'),
       (5, 'f', '2023-02-15'),
       (6, 'f', '1985-08-08'),
       (7, 'm', '1966-08-04'),
       (8, 'f', '2005-08-04'),
       (9, 'm', '2008-08-05'),
       (10, 'm', '2006-08-23'),
       (11, 'm', '1999-01-08');
INSERT INTO `messages` (`from_user_id`, `to_user_id`, `body`)
VALUES ('1', '11', 'Hi'),
       ('11', '1', 'Hello'),
       ('11', '1', 'How are you?'),
       ('1', '11', 'I`m fine, and you?'),
       ('1', '11', 'Hi'),
       ('1', '11', 'Hello'),
       ('1', '11', 'What`s up?'),
       ('11', '1', 'I`m fine too :)'),
       ('11', '1', 'bye');
DELETE
FROM `messages`
WHERE `id` = 8;

-- 4.* Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = true).
-- При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = false (или 0) (ALTER TABLE + UPDATE)
ALTER TABLE `profiles`
    ADD `is_active` BOOLEAN NOT NULL DEFAULT FALSE AFTER `hometown`;

UPDATE `profiles`
SET `is_active`= TRUE
WHERE TIMESTAMPDIFF(YEAR, `birthday`, CURDATE()) < 18;

-- 5.* Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)
DELETE
FROM `messages`
WHERE `created_at` > NOW();
DELETE
FROM `trash_messages`
WHERE created_at > NOW();