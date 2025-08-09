CREATE TABLE Contacts (
    ContactID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    ContactUserID INT,
    FOREIGN KEY (UserID) REFERENCES UserAccount(UserID),
    FOREIGN KEY (ContactUserID) REFERENCES UserAccount(UserID)
);
