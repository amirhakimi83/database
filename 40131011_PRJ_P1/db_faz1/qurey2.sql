SELECT ua.FirstName, ua.LastName, ua.PhoneNumber, ua.Username, COUNT(gm_messages.GroupMessageID) AS MessageCount
FROM UserAccount ua
INNER JOIN GroupMembers gm_members ON ua.UserID = gm_members.UserID
LEFT JOIN GroupMessages gm_messages ON gm_messages.SenderUserID = ua.UserID AND gm_messages.GroupChatID = gm_members.GroupChatID
WHERE gm_messages.GroupChatID = 1
GROUP BY ua.UserID
ORDER BY MessageCount DESC;
