USE `vk`;
-- Написать функцию, которая удаляет всю информацию об указанном пользователе из БД vk. Пользователь задается по id.
-- Удалить нужно все сообщения, лайки, медиа записи, профиль и запись из таблицы users. Функция должна возвращать номер пользователя.

-- ЧТОБЫ НЕ ПРИХОДИЛОСЬ ПИСАТЬ ПОДОБНЫЕ ФУНКЦИИ, ПРИ ПРОЕКТИРОВАНИИ БД ДОЛЖНЫ БЫТЬ КОРРЕКТНО СФОРМИРОВАНЫ ВСЕ СВЯЗИ
-- !! ТОГДА УДАЛЕНИЕ ПОЛЬЗОВАТЕЛЯ ПОВЛЕЧЕТ ЗА СОБОЙ УДАЛЕНИЕ ВСЕХ СВЯЗАННЫХ С НИМ СУЩНОСТЕЙ
DROP FUNCTION IF EXISTS DeleteUser;
-- SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER //

CREATE FUNCTION DeleteUser ( id BIGINT UNSIGNED)
    RETURNS BIGINT UNSIGNED

BEGIN

    DELETE FROM `users_communities` WHERE `user_id`=id;
    DELETE FROM `profiles` WHERE `user_id`=id;
    DELETE FROM `messages` WHERE `from_user_id`=id OR `to_user_id`=id;
    DELETE FROM `media` WHERE `user_id`=id;
    DELETE FROM `likes` WHERE `user_id`=id;
    DELETE FROM `friend_requests` WHERE `initiator_user_id`=id OR `target_user_id`=id;
    DELETE FROM `users_communities` WHERE `user_id`=id;
    DELETE FROM `users` AS u WHERE u.`id`=id;

    RETURN id;

END; //

DELIMITER ;

SELECT DeleteUser(99);

-- Предыдущую задачу решить с помощью процедуры и обернуть используемые команды в транзакцию внутри процедуры.
DROP PROCEDURE IF EXISTS DeleteUserProc;
DELIMITER //
CREATE PROCEDURE DeleteUserProc(id BIGINT UNSIGNED)

BEGIN
    START TRANSACTION;
    DELETE FROM `users_communities` WHERE `user_id` = id;
    DELETE FROM `profiles` WHERE `user_id` = id;
    DELETE FROM `messages` WHERE `from_user_id` = id OR `to_user_id` = id;
    DELETE FROM `media` WHERE `user_id` = id;
    DELETE FROM `likes` WHERE `user_id` = id;
    DELETE FROM `friend_requests` WHERE `initiator_user_id` = id OR `target_user_id` = id;
    DELETE FROM `users_communities` WHERE `user_id` = id;
    DELETE FROM `users` AS u WHERE u.`id` = id;
    COMMIT;
END;
//

DELIMITER ;

CALL DeleteUserProc(99);

-- * Написать триггер, который проверяет новое появляющееся сообщество. Длина названия сообщества (поле name) должна
-- быть не менее 5 символов. Если требование не выполнено, то выбрасывать исключение с пояснением.

DROP TRIGGER IF EXISTS `check_community`;
CREATE TRIGGER `check_community`
    BEFORE INSERT
    ON `communities`
    FOR EACH ROW IF (LENGTH(NEW.`name`) < 5) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'broken data for insert to communities table, check length name (must be >=5)';
END IF;