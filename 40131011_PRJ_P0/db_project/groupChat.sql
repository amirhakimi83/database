CREATE TABLE GroupChat (
    GroupChatID INT AUTO_INCREMENT PRIMARY KEY,
    GroupName VARCHAR(100),
    CreatorUserID INT,
    FOREIGN KEY (CreatorUserID) REFERENCES UserAccount(UserID)
);
