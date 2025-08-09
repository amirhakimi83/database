CREATE TABLE UserAccount (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) not null,
    LastName VARCHAR(50) not null,
    PhoneNumber VARCHAR(15) UNIQUE not null,
    Username VARCHAR(50) UNIQUE not null
);
