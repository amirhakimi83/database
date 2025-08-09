DELIMITER $$

CREATE FUNCTION count_messages_between_users(user1_id INT, user2_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE message_count INT;
    SELECT COUNT(*)
    INTO message_count
    FROM Message
    WHERE (SenderUserID = user1_id AND ChatID IN (SELECT ChatID FROM Chat WHERE UserID2 = user2_id))
       OR (SenderUserID = user2_id AND ChatID IN (SELECT ChatID FROM Chat WHERE UserID2 = user1_id));
    RETURN message_count;
END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION get_recent_active_users()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE active_users TEXT;
    SELECT GROUP_CONCAT(UserID) INTO active_users
    FROM (
        SELECT DISTINCT UserID
        FROM Message
        WHERE Timestamp >= NOW() - INTERVAL 1 DAY
    ) AS ActiveUsers;
    RETURN active_users;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE get_conversation_history(IN user1_id INT, IN user2_id INT, IN limit_value INT)
BEGIN
    DECLARE limit_var INT DEFAULT limit_value;
    SELECT * FROM Message WHERE ((SenderUserID = user1_id AND ReceiverUserID = user2_id) OR (SenderUserID = user2_id AND ReceiverUserID = user1_id)) ORDER BY Timestamp DESC LIMIT limit_var;
END$$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION search_messages(keyword TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE search_result TEXT;
    SELECT GROUP_CONCAT(CONCAT('MessageID: ', MessageID, ', User: ', SenderUserID, ', Content: ', Content, ', Timestamp: ', Timestamp) SEPARATOR '\n') INTO search_result
    FROM Message
    WHERE Content LIKE CONCAT('%', keyword, '%');
    RETURN search_result;
END$$

DELIMITER ;
