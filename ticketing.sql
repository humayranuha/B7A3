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

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id INT,
    user_id INT,
    match_id INT,
    seat_number VARCHAR(10),
    payment_status VARCHAR(20),
    total_cost DECIMAL(10,2),
    
    -- Primary Key constraint
    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    -- Foreign Key constraints
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_bookings_match FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    -- Check constraint for total cost
    CONSTRAINT chk_bookings_cost CHECK (total_cost >= 0),
    -- Check constraint for payment status
    CONSTRAINT chk_bookings_payment CHECK (payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded'))
);