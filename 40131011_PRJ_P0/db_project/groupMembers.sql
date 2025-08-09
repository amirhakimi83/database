CREATE TABLE GroupMembers (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    GroupChatID INT,
    UserID INT,
    FOREIGN KEY (GroupChatID) REFERENCES GroupChat(GroupChatID),
    FOREIGN KEY (UserID) REFERENCES UserAccount(UserID)
);
