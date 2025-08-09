SELECT ua.FirstName, ua.LastName, ua.PhoneNumber, ua.Username, GROUP_CONCAT(gc.GroupName SEPARATOR ', ') AS GroupNames
FROM UserAccount ua
LEFT JOIN GroupMembers gm ON ua.UserID = gm.UserID
JOIN GroupChat gc ON gm.GroupChatID = gc.GroupChatID
GROUP BY ua.UserID;
