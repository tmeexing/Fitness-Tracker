-- MySQL schema (reference + auto-loaded by docker-compose on first start).
-- The app also creates these tables on startup via SQLAlchemy if they're missing.

CREATE TABLE IF NOT EXISTS users (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(255) NOT NULL UNIQUE,
    height_cm  DECIMAL(5,1) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Calories IN (food / meals)
CREATE TABLE IF NOT EXISTS calorie_intake (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    food_name   VARCHAR(150) NOT NULL,
    meal_type   ENUM('breakfast','lunch','dinner','snack') NOT NULL DEFAULT 'snack',
    calories    INT NOT NULL CHECK (calories >= 0),
    protein_g   DECIMAL(6,1) NULL,
    carbs_g     DECIMAL(6,1) NULL,
    fat_g       DECIMAL(6,1) NULL,
    consumed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_intake_user_time (user_id, consumed_at)
);

-- Calories OUT (exercise / activity)
CREATE TABLE IF NOT EXISTS calorie_outtake (
    id              INT AUTO_INCREMENT PRIMARY KEY,
    user_id         INT NOT NULL,
    activity        VARCHAR(150) NOT NULL,
    duration_min    INT NULL CHECK (duration_min >= 0),
    calories_burned INT NOT NULL CHECK (calories_burned >= 0),
    burned_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_outtake_user_time (user_id, burned_at)
);

-- Weight log
CREATE TABLE IF NOT EXISTS weight_entries (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    weight_kg   DECIMAL(5,2) NOT NULL CHECK (weight_kg > 0),
    recorded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_weight_user_time (user_id, recorded_at)
);
