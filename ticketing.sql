-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
drop table if exists bookings;
drop table if exists matches;
drop table if exists users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
create table users (
   user_id      int,
   full_name    varchar(100),
   email        varchar(100),
   role         varchar(50),
   phone_number varchar(20),
    
    -- Primary Key constraint
   constraint pk_users primary key ( user_id ),
    -- Unique email constraint
   constraint uk_users_email unique ( email ),
    -- Check constraint for role
   constraint chk_users_role check ( role in ( 'Football Fan',
                                               'Ticket Manager' ) )
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
create table matches (
   match_id            int,
   fixture             varchar(100),
   tournament_category varchar(50),
   base_ticket_price   decimal(10,2),
   match_status        varchar(20),
    
    -- Primary Key constraint
   constraint pk_matches primary key ( match_id ),
    -- Check constraint for non-negative price
   constraint chk_matches_price check ( base_ticket_price >= 0 ),
    -- Check constraint for match status
   constraint chk_matches_status
      check ( match_status in ( 'Available',
                                'Selling Fast',
                                'Sold Out',
                                'Postponed' ) )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
create table bookings (
   booking_id     int,
   user_id        int,
   match_id       int,
   seat_number    varchar(10),
   payment_status varchar(20),
   total_cost     decimal(10,2),
    
    -- Primary Key constraint
   constraint pk_bookings primary key ( booking_id ),
    -- Foreign Key constraints
   constraint fk_bookings_user foreign key ( user_id )
      references users ( user_id ),
   constraint fk_bookings_match foreign key ( match_id )
      references matches ( match_id ),
    -- Check constraint for total cost
   constraint chk_bookings_cost check ( total_cost >= 0 ),
    -- Check constraint for payment status
   constraint chk_bookings_payment
      check ( payment_status in ( 'Pending',
                                  'Confirmed',
                                  'Cancelled',
                                  'Refunded' ) )
);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
insert into users (
   user_id,
   full_name,
   email,
   role,
   phone_number
) values ( 1,
           'Tanvir Rahman',
           'tanvir@mail.com',
           'Football Fan',
           '+8801711111111' ),( 2,
                                'Asif Haque',
                                'asif@mail.com',
                                'Football Fan',
                                '+8801722222222' ),( 3,
                                                     'Sajjad Rahman',
                                                     'sajjad@mail.com',
                                                     'Ticket Manager',
                                                     '+8801733333333' ),( 4,
                                                                          'Jannat Ara',
                                                                          'jannat@mail.com',
                                                                          'Football Fan',
                                                                          null );

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
insert into matches (
   match_id,
   fixture,
   tournament_category,
   base_ticket_price,
   match_status
) values ( 101,
           'Real Madrid vs Barcelona',
           'Champions League',
           150.00,
           'Available' ),( 102,
                           'Man City vs Liverpool',
                           'Premier League',
                           120.00,
                           'Selling Fast' ),( 103,
                                              'Bayern Munich vs PSG',
                                              'Champions League',
                                              130.00,
                                              'Available' ),( 104,
                                                              'AC Milan vs Inter Milan',
                                                              'Serie A',
                                                              90.00,
                                                              'Sold Out' ),( 105,
                                                                             'Juventus vs Roma',
                                                                             'Serie A',
                                                                             80.00,
                                                                             'Available' );

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
insert into bookings (
   booking_id,
   user_id,
   match_id,
   seat_number,
   payment_status,
   total_cost
) values ( 501,
           1,
           101,
           'A-12',
           'Confirmed',
           150.00 ),( 502,
                      1,
                      102,
                      'B-04',
                      'Confirmed',
                      120.00 ),( 503,
                                 2,
                                 101,
                                 'A-13',
                                 'Confirmed',
                                 150.00 ),( 504,
                                            2,
                                            101,
                                            null,
                                            null,
                                            150.00 ),( 505,
                                                       3,
                                                       102,
                                                       'C-20',
                                                       'Pending',
                                                       120.00 );

-- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' 
-- where the match status is 'Available'.
select match_id,
       fixture,
       base_ticket_price
  from matches
 where tournament_category = 'Champions League'
   and match_status = 'Available';

-- Query 2: Search for all users whose full names start with 'Tanvir' 
-- or contain the phrase 'Haque' (case-insensitive).
SELECT user_id, full_name, email
FROM Users
WHERE full_name ILIKE 'Tanvir%' 
   OR full_name ILIKE '%Haque%';

-- Query 3: Retrieve all booking records where the payment status is missing (NULL),
-- replacing the empty result with 'Action Required'.
SELECT 
    booking_id, 
    user_id, 
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;

-- Query 4: Retrieve match booking details along with the User's full name 
-- and the scheduled Match fixture teams.
SELECT 
    b.booking_id,
    u.full_name,
    m.fixture,
    b.total_cost
FROM Bookings b
INNER JOIN Users u ON b.user_id = u.user_id
INNER JOIN Matches m ON b.match_id = m.match_id;

-- Query 5: Display a comprehensive list of all users and their booking IDs,
-- ensuring that fans who have never bought a ticket are still listed.
SELECT 
    u.user_id,
    u.full_name,
    b.booking_id
FROM Users u
LEFT JOIN Bookings b ON u.user_id = b.user_id
ORDER BY u.user_id, b.booking_id;

-- Query 6: Find all ticket bookings where the total cost is strictly higher 
-- than the average cost of all ticket bookings.
SELECT booking_id, match_id, total_cost
FROM Bookings
WHERE total_cost > (SELECT AVG(total_cost) FROM Bookings);