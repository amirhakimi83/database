DELIMITER $$

CREATE TRIGGER check_unique_phone_before_insert
BEFORE INSERT ON UserAccount
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM UserAccount WHERE PhoneNumber = NEW.PhoneNumber) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate phone number is not allowed.';
    END IF;
END;$$

CREATE TRIGGER check_unique_phone_before_update
BEFORE UPDATE ON UserAccount
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM UserAccount WHERE PhoneNumber = NEW.PhoneNumber AND UserID <> OLD.UserID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Duplicate phone number is not allowed.';
    END IF;
END;$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER check_group_ownership_after_insert
AFTER INSERT ON GroupMembers
FOR EACH ROW
BEGIN
    DECLARE member_count INT;
    SELECT COUNT(DISTINCT UserID) INTO member_count FROM GroupMembers WHERE GroupChatID = NEW.GroupChatID;
    IF member_count < 2 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Each group must be owned by at least two members.';
    END IF;
END;$$

DELIMITER ;
