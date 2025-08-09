
CREATE INDEX idx_firstname_lastname ON UserAccount (FirstName, LastName);
CREATE INDEX idx_phone_number ON UserAccount (PhoneNumber);
CREATE INDEX idx_username ON UserAccount (Username);

CREATE INDEX idx_chatid ON Message (ChatID);
CREATE INDEX idx_senderuserid ON Message (SenderUserID);

CREATE INDEX idx_groupchatid ON GroupMessages (GroupChatID);
CREATE INDEX idx_senderuserid ON GroupMessages (SenderUserID);
