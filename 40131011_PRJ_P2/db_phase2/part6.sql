CREATE TABLE ChangeLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ChangeType VARCHAR(10),
    TableName VARCHAR(50),
    RecordID INT,
    ChangeTime DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER after_user_insert
AFTER INSERT ON UserAccount
FOR EACH ROW
BEGIN
    INSERT INTO ChangeLog (ChangeType, TableName, RecordID)
    VALUES ('INSERT', 'UserAccount', NEW.UserID);
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_user_update
AFTER UPDATE ON UserAccount
FOR EACH ROW
BEGIN
    INSERT INTO ChangeLog (ChangeType, TableName, RecordID)
    VALUES ('UPDATE', 'UserAccount', NEW.UserID);
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER after_user_delete
AFTER DELETE ON UserAccount
FOR EACH ROW
BEGIN
    INSERT INTO ChangeLog (ChangeType, TableName, RecordID)
    VALUES ('DELETE', 'UserAccount', OLD.UserID);
END$$

DELIMITER ;
