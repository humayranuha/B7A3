-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id INT,
    full_name VARCHAR(100),
    email VARCHAR(100),
    role VARCHAR(50),
    phone_number VARCHAR(20),
    
    -- Primary Key constraint
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    -- Unique email constraint
    CONSTRAINT uk_users_email UNIQUE (email),
    -- Check constraint for role
    CONSTRAINT chk_users_role CHECK (role IN ('Football Fan', 'Ticket Manager'))
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id INT,
    fixture VARCHAR(100),
    tournament_category VARCHAR(50),
    base_ticket_price DECIMAL(10,2),
    match_status VARCHAR(20),
    
    -- Primary Key constraint
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    -- Check constraint for non-negative price
    CONSTRAINT chk_matches_price CHECK (base_ticket_price >= 0),
    -- Check constraint for match status
    CONSTRAINT chk_matches_status CHECK (match_status IN ('Available', 'Selling Fast', 'Sold Out', 'Postponed'))
);