CREATE DATABASE IF NOT EXISTS zip_game CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS zip_game_test CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'zip_user'@'localhost' IDENTIFIED BY 'zip_password123';
CREATE USER IF NOT EXISTS 'zip_user'@'127.0.0.1' IDENTIFIED BY 'zip_password123';
CREATE USER IF NOT EXISTS 'zip_user'@'%' IDENTIFIED BY 'zip_password123';

ALTER USER 'zip_user'@'localhost' IDENTIFIED BY 'zip_password123';
ALTER USER 'zip_user'@'127.0.0.1' IDENTIFIED BY 'zip_password123';
ALTER USER 'zip_user'@'%' IDENTIFIED BY 'zip_password123';

GRANT ALL PRIVILEGES ON zip_game.* TO 'zip_user'@'localhost';
GRANT ALL PRIVILEGES ON zip_game.* TO 'zip_user'@'127.0.0.1';
GRANT ALL PRIVILEGES ON zip_game.* TO 'zip_user'@'%';

GRANT ALL PRIVILEGES ON zip_game_test.* TO 'zip_user'@'localhost';
GRANT ALL PRIVILEGES ON zip_game_test.* TO 'zip_user'@'127.0.0.1';
GRANT ALL PRIVILEGES ON zip_game_test.* TO 'zip_user'@'%';

FLUSH PRIVILEGES;

