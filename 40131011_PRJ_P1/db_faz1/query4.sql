SET @SpecificDate = '2024-06-03'; 

WITH ActiveUsersOnSpecificDate AS (
    SELECT DISTINCT UserID
    FROM LoginLog
    WHERE DATE(LoginDateTime) = @SpecificDate
),

UserMessagesPerGroup AS (
    SELECT 
        GM.UserID, 
        GC.GroupChatID, 
        COUNT(*) AS MessagesSent
    FROM GroupMembers GM
    JOIN GroupChat GC ON GM.GroupChatID = GC.GroupChatID
    JOIN GroupMessages GMsg ON GM.UserID = GMsg.SenderUserID AND GC.GroupChatID = GMsg.GroupChatID
    WHERE DATE(GMsg.Timestamp) = @SpecificDate
    GROUP BY GM.UserID, GC.GroupChatID
),

UsersWithMultipleGroupMessages AS (
    SELECT 
        UOSD.UserID
    FROM ActiveUsersOnSpecificDate UOSD
    JOIN UserMessagesPerGroup UMPG ON UOSD.UserID = UMPG.UserID
    GROUP BY UOSD.UserID
    HAVING COUNT(DISTINCT UMPG.GroupChatID) >= 2 AND SUM(UMPG.MessagesSent) > 1
)

SELECT UA.*
FROM UsersWithMultipleGroupMessages UWMM
JOIN UserAccount UA ON UWMM.UserID = UA.UserID;
