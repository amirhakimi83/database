CREATE TABLE GroupMessages (
    GroupMessageID INT AUTO_INCREMENT PRIMARY KEY,
    GroupChatID INT,
    SenderUserID INT,
    Content TEXT,
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (GroupChatID) REFERENCES GroupChat(GroupChatID),
    FOREIGN KEY (SenderUserID) REFERENCES UserAccount(UserID)
);
