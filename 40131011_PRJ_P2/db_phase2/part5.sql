CREATE USER 'Azad_Arousha'@'localhost' IDENTIFIED BY 'azad2000Arousha';

GRANT SELECT ON *.* TO 'Azad_Arousha'@'localhost';

REVOKE INSERT, UPDATE, DELETE ON *.* FROM 'Azad_Arousha'@'localhost';

FLUSH PRIVILEGES;
