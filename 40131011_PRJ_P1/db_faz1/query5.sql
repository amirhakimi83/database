SET @SpecificUserID = 11; 
WITH SpecificGroups AS (
    SELECT DISTINCT GroupChatID
    FROM GroupMembers
    WHERE UserID = @SpecificUserID
),
CommonGroupMembers AS (
    SELECT DISTINCT GM.UserID
    FROM GroupMembers GM
    INNER JOIN SpecificGroups SG ON GM.GroupChatID = SG.GroupChatID
    WHERE GM.UserID!= @SpecificUserID
)
SELECT UA.*
FROM CommonGroupMembers CGM
INNER JOIN UserAccount UA ON CGM.UserID = UA.UserID;
