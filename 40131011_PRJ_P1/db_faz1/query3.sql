SELECT g.GroupChatID, COUNT(DISTINCT u.UserID) AS NumberOfUsersInGroup FROM GroupChat g
JOIN GroupMembers gm ON g.GroupChatID = gm.GroupChatID
JOIN UserAccount u ON gm.UserID = u.UserID
WHERE EXISTS (
        SELECT 1 FROM Chat c WHERE c.UserID1 = u.UserID OR c.UserID2 = u.UserID AND c.UserID1!= c.UserID2
)
GROUP BY g.GroupChatID;
