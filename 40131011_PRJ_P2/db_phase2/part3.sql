CREATE VIEW messege_user AS
SELECT 
    M.MessageID, 
    M.ChatID, 
    M.SenderUserID, 
    UA.FirstName AS SenderFirstName, 
    UA.LastName AS SenderLastName, 
    M.Content, 
    M.Timestamp
FROM 
    Message M
JOIN 
    UserAccount UA ON M.SenderUserID = UA.UserID;

CREATE VIEW contacts_user AS
SELECT 
    UA.UserID, 
    UA.FirstName, 
    UA.LastName, 
    C.ContactUserID, 
    UC.FirstName AS ContactFirstName, 
    UC.LastName AS ContactLastName
FROM 
    UserAccount UA
JOIN 
    Contacts C ON UA.UserID = C.UserID
JOIN 
    UserAccount UC ON C.ContactUserID = UC.UserID;


CREATE VIEW group_messege_user AS
SELECT 
    GM.GroupMessageID, 
    GC.GroupChatID, 
    GC.GroupName, 
    GM.SenderUserID, 
    UA.FirstName AS SenderFirstName, 
    UA.LastName AS SenderLastName, 
    GM.Content, 
    GM.Timestamp
FROM 
    GroupMessages GM
JOIN 
    GroupChat GC ON GM.GroupChatID = GC.GroupChatID
JOIN 
    UserAccount UA ON GM.SenderUserID = UA.UserID;
