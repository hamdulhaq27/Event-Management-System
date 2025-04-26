-- Group Information:
-- Members: Hamd-Ul-Haq (23i-0081), Haider Abbas (23i-2558), Saif Shahzad (23i-2634)

-- Creating Database --
create database dbProject;
use dbProject;

-- drop database dbProject; --

-- Creating Tables Using DDL Commands --

-- User Table --
CREATE TABLE User(
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    UserName VARCHAR(100) NOT NULL,
    `Password` VARCHAR(255) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(100) UNIQUE NOT NULL,
    UserRole VARCHAR(100) NOT NULL,
    City VARCHAR(100),
    ZipCode INT,
    RegistrationDate DATE NOT NULL,
    CONSTRAINT userRole CHECK(UserRole IN('Admin','Organizer','Participant','Judge','Sponsor'))
);

-- Venue Table --
CREATE TABLE Venue(
    VenueID INT PRIMARY KEY AUTO_INCREMENT,
    VenueName VARCHAR(100) NOT NULL,
    VenueType VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    VenueStatus VARCHAR(100) NOT NULL,
    CONSTRAINT venueType CHECK(VenueType IN('Auditorium','Hall','Lab','Outdoor')),
    CONSTRAINT venueStatus CHECK(VenueStatus IN('Available','Booked','Maintenance')),
    CONSTRAINT capacity CHECK(Capacity>=0)
);

-- Event Table --
CREATE TABLE Event(
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    EventName VARCHAR(100) NOT NULL,
    EventDescription TEXT,
    Category VARCHAR(100),
    Rules TEXT,
    MaxParticipants INT,
    RegistrationFee DECIMAL(10,2),
    StartDateTime DATETIME,
    EndDateTime DATETIME,
    EventStatus VARCHAR(100),
    VenueID INT,
    Round VARCHAR(100),
    CONSTRAINT category CHECK(Category IN ('Tech','Business','Gaming','General')),
    CONSTRAINT eventStatus CHECK(EventStatus IN('Upcoming','Ongoing','Completed')),
    CONSTRAINT round CHECK(Round IN('Prelims','Semi-Finals','Finals')),
    CONSTRAINT maxParticipants CHECK(MaxParticipants>=0),
    CONSTRAINT registrationFee CHECK(RegistrationFee>=0),
    FOREIGN KEY (VenueID) REFERENCES Venue(VenueID)
);

-- Team Table --
CREATE TABLE Team(
    TeamID INT PRIMARY KEY AUTO_INCREMENT,
    TeamName VARCHAR(100) NOT NULL,
    LeaderID INT,
    TeamSize INT,
    CONSTRAINT teamSize CHECK(TeamSize>0),
    FOREIGN KEY (LeaderID) REFERENCES User(UserID)
);

-- Score Table --
CREATE TABLE Score(
    ScoreID INT PRIMARY KEY AUTO_INCREMENT,
    ScoreValue INT NOT NULL,
    JudgeID INT,
    EventID INT,
    ParticipantID INT NULL,
    TeamID INT NULL,
    ScoreRound VARCHAR(100),
    CONSTRAINT scoreValue CHECK(ScoreValue>=0),
    CONSTRAINT scoreRound CHECK (ScoreRound IN ('Prelims','Semi-Finals','Finals')),
    FOREIGN KEY (JudgeID) REFERENCES User(UserID),
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (ParticipantID) REFERENCES User(UserID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

-- Sponsorship Table --
CREATE TABLE Sponsorship(
    SponsorshipID INT PRIMARY KEY AUTO_INCREMENT,
    SponsorID INT,
    Package VARCHAR(100) NOT NULL,
    Amount DECIMAL(10,2),
    SponsorShipDescription TEXT,
    StartDate DATE,
    EndDate DATE,
    SponsorShipStatus VARCHAR(100),
    CONSTRAINT package CHECK(Package IN('Title','Gold','Silver','Media')),
    CONSTRAINT sponsorshipStatus CHECK(SponsorShipStatus IN('Pending','Active','Completed')),
    CONSTRAINT amount CHECK(Amount>=0),
    FOREIGN KEY (SponsorID) REFERENCES User(UserID)
);

-- Accommodation Table --
CREATE TABLE Accommodation(
    AccommodationID INT PRIMARY KEY AUTO_INCREMENT,
    AccommodationName VARCHAR(100) NOT NULL,
    AccommodationType VARCHAR(100),
    accommodationCity VARCHAR(100),
    accommodationZip INT,
    RoomNumber VARCHAR(100),
    AccommodationCapacity INT,
    PricePerNight DECIMAL(10,2),
    AccommodationStatus VARCHAR(100),
    CONSTRAINT accommodationType CHECK(AccommodationType IN('Hostel','Hotel','Other')),
    CONSTRAINT accommodationStatus CHECK(AccommodationStatus IN('Available','Occupied')),
    CONSTRAINT accommodationCapacity CHECK(AccommodationCapacity>=0),
    CONSTRAINT price CHECK(PricePerNight>=0)
);

-- Payment Table --
CREATE TABLE Payment(
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    PaymentAmount DECIMAL(10,2) NOT NULL,
    PaymentDate DATE,
    PaymentMethod VARCHAR(100),
    PaymentStatus VARCHAR(100),
    PaymentType VARCHAR(100),
    UserID INT,
    EventID INT,
    AccommodationID INT,
    SponsorshipID INT,
    CONSTRAINT paymentStatus CHECK(PaymentStatus IN('Pending','Completed','Failed')),
    CONSTRAINT paymentType CHECK(PaymentType IN('Registration','Sponsorship','Accommodation')),
    CONSTRAINT paymentAmount CHECK(PaymentAmount>=0),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (EventID) REFERENCES Event(EventID),
    FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID),
    FOREIGN KEY (SponsorshipID) REFERENCES Sponsorship(SponsorshipID)
);

-- Many to many relationship tables --

CREATE TABLE userEvent(
    UserID INT,
    EventID INT,
    PRIMARY KEY (UserID,EventID),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

CREATE TABLE userTeam(
    UserID INT,
    TeamID INT,
    PRIMARY KEY (UserID,TeamID),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID)
);

CREATE TABLE teamEvent(
    TeamID INT,
    EventID INT,
    PRIMARY KEY (TeamID,EventID),
    FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

CREATE TABLE userAccommodation(
    UserID INT,
    AccommodationID INT,
    PRIMARY KEY (UserID,AccommodationID),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (AccommodationID) REFERENCES Accommodation(AccommodationID)
);

-- Inserting data into User table
INSERT INTO User (UserName, Password, Email, Phone, UserRole, City, ZipCode, RegistrationDate) VALUES
('Admin1', 'adminpass1', 'admin1@email.com', '12345678901', 'Admin', 'Karachi', 75500, '2023-01-01'),
('Organizer1', 'orgpass1', 'organizer1@email.com', '12345678902', 'Organizer', 'Lahore', 54000, '2023-01-02'),
('Participant1', 'partpass1', 'participant1@email.com', '12345678903', 'Participant', 'Islamabad', 44000, '2023-01-03'),
('Judge1', 'judgepass1', 'judge1@email.com', '12345678904', 'Judge', 'Peshawar', 25000, '2023-01-04'),
('Sponsor1', 'sponpass1', 'sponsor1@email.com', '12345678905', 'Sponsor', 'Quetta', 87300, '2023-01-05'),
('Participant2', 'partpass2', 'participant2@email.com', '12345678906', 'Participant', 'Faisalabad', 38000, '2023-01-06'),
('Participant3', 'partpass3', 'participant3@email.com', '12345678907', 'Participant', 'Multan', 60000, '2023-01-07'),
('Organizer2', 'orgpass2', 'organizer2@email.com', '12345678908', 'Organizer', 'Hyderabad', 71000, '2023-01-08'),
('Judge2', 'judgepass2', 'judge2@email.com', '12345678909', 'Judge', 'Rawalpindi', 46000, '2023-01-09'),
('Sponsor2', 'sponpass2', 'sponsor2@email.com', '12345678910', 'Sponsor', 'Gujranwala', 52250, '2023-01-10');

-- Inserting data into Venue table
INSERT INTO Venue (VenueName, VenueType, Capacity, VenueStatus) VALUES
('Main Auditorium', 'Auditorium', 500, 'Available'),
('Conference Hall A', 'Hall', 200, 'Available'),
('Computer Lab 1', 'Lab', 50, 'Maintenance'),
('Sports Ground', 'Outdoor', 1000, 'Booked'),
('Seminar Hall B', 'Hall', 150, 'Available'),
('Innovation Lab', 'Lab', 30, 'Available'),
('Open Air Theater', 'Outdoor', 800, 'Available'),
('Lecture Hall C', 'Hall', 100, 'Available'),
('Robotics Lab', 'Lab', 40, 'Booked'),
('Exhibition Hall', 'Hall', 300, 'Available');

-- Inserting data into Event table
INSERT INTO Event (EventName, EventDescription, Category, Rules, MaxParticipants, RegistrationFee, StartDateTime, EndDateTime, EventStatus, VenueID, Round) VALUES
('Tech Hackathon', 'Annual coding competition', 'Tech', 'No pre-written code allowed', 50, 1000.00, '2023-06-15 09:00:00', '2023-06-16 18:00:00', 'Upcoming', 1, 'Prelims'),
('Business Plan Competition', 'Present your startup ideas', 'Business', 'Teams of 3-5 members', 30, 1500.00, '2023-07-10 10:00:00', '2023-07-12 16:00:00', 'Upcoming', 2, 'Semi-Finals'),
('Gaming Tournament', 'Esports competition', 'Gaming', 'Bring your own controller', 100, 500.00, '2023-05-20 12:00:00', '2023-05-21 20:00:00', 'Ongoing', 4, 'Finals'),
('Debate Competition', 'Inter-university debate', 'General', '5 minutes per speaker', 40, 800.00, '2023-04-25 14:00:00', '2023-04-26 18:00:00', 'Completed', 5, 'Finals'),
('AI Workshop', 'Learn AI fundamentals', 'Tech', 'Bring your laptop', 60, 2000.00, '2023-08-05 09:30:00', '2023-08-07 17:00:00', 'Upcoming', 6, 'Prelims'),
('Robotics Challenge', 'Build and program robots', 'Tech', 'Teams of 2-4 members', 25, 1200.00, '2023-09-12 10:00:00', '2023-09-14 15:00:00', 'Upcoming', 9, 'Prelims'),
('Case Study Competition', 'Solve business cases', 'Business', 'Individual participation', 35, 900.00, '2023-07-22 11:00:00', '2023-07-23 19:00:00', 'Upcoming', 8, 'Semi-Finals'),
('Art Exhibition', 'Showcase your artwork', 'General', 'Original work only', 80, 400.00, '2023-05-15 10:00:00', '2023-05-17 20:00:00', 'Ongoing', 10, 'Finals'),
('Mobile App Development', 'Create innovative apps', 'Tech', 'Teams of 1-3 members', 45, 1500.00, '2023-10-01 09:00:00', '2023-10-03 18:00:00', 'Upcoming', 3, 'Prelims'),
('Startup Pitch', 'Pitch to investors', 'Business', '5 minute pitch + 3 min Q&A', 20, 2000.00, '2023-11-05 13:00:00', '2023-11-06 17:00:00', 'Upcoming', 7, 'Finals');

-- Inserting data into Team table
INSERT INTO Team (TeamName, LeaderID, TeamSize) VALUES
('Code Masters', 3, 4),
('Business Wizards', 6, 3),
('Gaming Legends', 7, 5),
('Debate Club', 6, 2),
('AI Enthusiasts', 3, 3),
('Robo Team', 7, 4),
('Case Solvers', 6, 1),
('Art Collective', 7, 6),
('App Developers', 3, 2),
('Startup Founders', 6, 4);

-- Inserting data into Score table
INSERT INTO Score (ScoreValue, JudgeID, EventID, ParticipantID, TeamID, ScoreRound) VALUES
(85, 4, 1, NULL, 1, 'Prelims'),
(90, 9, 2, NULL, 2, 'Semi-Finals'),
(78, 4, 3, 7, NULL, 'Finals'),
(92, 9, 4, 6, NULL, 'Finals'),
(88, 4, 5, NULL, 5, 'Prelims'),
(95, 9, 6, NULL, 6, 'Prelims'),
(82, 4, 7, 6, NULL, 'Semi-Finals'),
(89, 9, 8, NULL, 8, 'Finals'),
(91, 4, 9, NULL, 9, 'Prelims'),
(87, 9, 10, NULL, 10, 'Finals');

-- Inserting data into Sponsorship table
INSERT INTO Sponsorship (SponsorID, Package, Amount, SponsorShipDescription, StartDate, EndDate, SponsorShipStatus) VALUES
(5, 'Gold', 50000.00, 'Main event sponsor', '2023-05-01', '2023-12-31', 'Active'),
(10, 'Silver', 25000.00, 'Supporting sponsor', '2023-04-15', '2023-11-30', 'Active'),
(5, 'Media', 10000.00, 'Social media coverage', '2023-06-01', '2023-10-31', 'Pending'),
(10, 'Title', 100000.00, 'Title sponsor for tech events', '2023-03-01', '2023-12-31', 'Active'),
(5, 'Silver', 30000.00, 'Sponsorship for gaming event', '2023-04-01', '2023-05-31', 'Completed'),
(10, 'Gold', 60000.00, 'Primary business event sponsor', '2023-07-01', '2023-12-31', 'Pending'),
(5, 'Media', 15000.00, 'Promotional materials', '2023-08-01', '2023-12-31', 'Pending'),
(10, 'Silver', 20000.00, 'Workshop sponsorship', '2023-09-01', '2023-10-31', 'Pending'),
(5, 'Gold', 75000.00, 'Annual sponsorship', '2023-01-01', '2023-12-31', 'Active'),
(10, 'Title', 120000.00, 'Premier sponsorship', '2023-02-01', '2023-12-31', 'Active');

-- Inserting data into Accommodation table
INSERT INTO Accommodation (AccommodationName, AccommodationType, accommodationCity, accommodationZip, RoomNumber, AccommodationCapacity, PricePerNight, AccommodationStatus) VALUES
('University Hostel', 'Hostel', 'Karachi', 75500, 'H101', 4, 1000.00, 'Available'),
('Grand Hotel', 'Hotel', 'Lahore', 54000, 'GH201', 2, 5000.00, 'Occupied'),
('Tech Guest House', 'Other', 'Islamabad', 44000, 'TGH301', 3, 3000.00, 'Available'),
('City Inn', 'Hotel', 'Peshawar', 25000, 'CI401', 2, 4000.00, 'Available'),
('Students Lodge', 'Hostel', 'Quetta', 87300, 'SL501', 6, 800.00, 'Occupied'),
('Business Suites', 'Hotel', 'Faisalabad', 38000, 'BS601', 1, 6000.00, 'Available'),
('Conference Center', 'Other', 'Multan', 60000, 'CC701', 4, 2500.00, 'Available'),
('Plaza Hotel', 'Hotel', 'Hyderabad', 71000, 'PH801', 2, 4500.00, 'Occupied'),
('Innovation Hub', 'Other', 'Rawalpindi', 46000, 'IH901', 5, 2000.00, 'Available'),
('Garden Hostel', 'Hostel', 'Gujranwala', 52250, 'GH1001', 8, 1200.00, 'Available');

-- Inserting data into Payment table
INSERT INTO Payment (PaymentAmount, PaymentDate, PaymentMethod, PaymentStatus, PaymentType, UserID, EventID, AccommodationID, SponsorshipID) VALUES
(1000.00, '2023-05-01', 'Credit Card', 'Completed', 'Registration', 3, 1, NULL, NULL),
(1500.00, '2023-06-15', 'Bank Transfer', 'Completed', 'Registration', 6, 2, NULL, NULL),
(500.00, '2023-04-10', 'Cash', 'Completed', 'Registration', 7, 3, NULL, NULL),
(800.00, '2023-03-20', 'Credit Card', 'Completed', 'Registration', 6, 4, NULL, NULL),
(2000.00, '2023-07-01', 'Bank Transfer', 'Pending', 'Registration', 3, 5, NULL, NULL),
(50000.00, '2023-04-28', 'Bank Transfer', 'Completed', 'Sponsorship', 5, NULL, NULL, 1),
(3000.00, '2023-05-15', 'Credit Card', 'Completed', 'Accommodation', 3, NULL, 3, NULL),
(25000.00, '2023-04-10', 'Bank Transfer', 'Completed', 'Sponsorship', 10, NULL, NULL, 2),
(1200.00, '2023-08-20', 'Cash', 'Pending', 'Registration', 7, 6, NULL, NULL),
(6000.00, '2023-06-01', 'Credit Card', 'Completed', 'Accommodation', 6, NULL, 6, NULL);

-- Inserting data into userEvent table
INSERT INTO userEvent (UserID, EventID) VALUES
(3, 1),
(6, 2),
(7, 3),
(6, 4),
(3, 5),
(7, 6),
(6, 7),
(7, 8),
(3, 9),
(6, 10);

-- Inserting data into userTeam table
INSERT INTO userTeam (UserID, TeamID) VALUES
(3, 1),
(6, 2),
(7, 3),
(6, 4),
(3, 5),
(7, 6),
(6, 7),
(7, 8),
(3, 9),
(6, 10);

-- Inserting data into teamEvent table
INSERT INTO teamEvent (TeamID, EventID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Inserting data into userAccommodation table
INSERT INTO userAccommodation (UserID, AccommodationID) VALUES
(3, 3),
(6, 6),
(7, 1);

DELETE FROM userAccommodation;
SET SQL_SAFE_UPDATES = 0;

DELIMITER //

CREATE TRIGGER before_user_accommodation_insert
BEFORE INSERT ON userAccommodation
FOR EACH ROW
BEGIN
    DECLARE user_count INT;

    SELECT COUNT(*) INTO user_count
    FROM userAccommodation
    WHERE UserID = NEW.UserID;

    IF user_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User already has an accommodation assigned!';
    END IF;
END //

DELIMITER ;

SELECT u.UserID, u.UserName, u.Email, u.Phone
FROM User u
JOIN userEvent ue ON u.UserID = ue.UserID
WHERE ue.EventID = 1 AND u.UserRole = 'Participant';

SELECT SUM(Amount) AS TotalSponsorshipFunds
FROM Sponsorship
WHERE SponsorShipStatus = 'Active';

SELECT E.EventName, AVG(S.ScoreValue) AS AverageScore
FROM Score S
INNER JOIN Event E ON S.EventID = E.EventID
WHERE S.ScoreRound = 'Finals'
GROUP BY E.EventName
HAVING AVG(S.ScoreValue) > 80;

SELECT U.UserName, U.Email, A.AccommodationName, A.RoomNumber
FROM User U
INNER JOIN userAccommodation UA ON U.UserID = UA.UserID
INNER JOIN Accommodation A ON UA.AccommodationID = A.AccommodationID
WHERE U.UserRole = 'Participant';

SELECT SP.SponsorshipID, U.UserName AS SponsorName, SP.Package, SP.Amount, P.PaymentAmount, P.PaymentStatus
FROM Sponsorship SP
LEFT JOIN Payment P ON SP.SponsorshipID = P.SponsorshipID
LEFT JOIN User U ON SP.SponsorID = U.UserID;

SELECT E1.EventName AS Event1, E2.EventName AS Event2, V.VenueName, E1.StartDateTime, E2.StartDateTime
FROM Event E1
JOIN Event E2 ON E1.VenueID = E2.VenueID
JOIN Venue V ON E1.VenueID = V.VenueID
WHERE E1.EventID < E2.EventID 
  AND (
    (E1.StartDateTime BETWEEN E2.StartDateTime AND E2.EndDateTime) OR
    (E2.StartDateTime BETWEEN E1.StartDateTime AND E1.EndDateTime)
  );
  
  CREATE VIEW ParticipantList AS
SELECT U.UserID, U.UserName, U.Email, E.EventName
FROM User U
INNER JOIN userEvent UE ON U.UserID = UE.UserID
INNER JOIN Event E ON UE.EventID = E.EventID
WHERE U.UserRole = 'Participant';

select * from participantlsit;

CREATE INDEX idx_user_email ON User(Email);
CREATE INDEX idx_event_name ON Event(EventName);
CREATE INDEX idx_accommodation_status ON Accommodation(AccommodationStatus);

SHOW INDEXES FROM User;
SHOW INDEXES FROM Event;
SHOW INDEXES FROM Accommodation;

DELIMITER //

CREATE PROCEDURE AutoScheduleEvent(
    IN p_EventName VARCHAR(100),
    IN p_Category VARCHAR(100),
    IN p_StartDateTime DATETIME,
    IN p_EndDateTime DATETIME,
    IN p_VenueID INT
)
BEGIN
    INSERT INTO Event (EventName, Category, StartDateTime, EndDateTime, EventStatus, VenueID, Round)
    VALUES (p_EventName, p_Category, p_StartDateTime, p_EndDateTime, 'Upcoming', p_VenueID, 'Prelims');
END //

DELIMITER ;

CALL AutoScheduleEvent('Hackathon 2025', 'Tech', '2025-05-01 09:00:00', '2025-05-01 18:00:00', 1);

DELIMITER //

CREATE TRIGGER after_payment_insert
AFTER INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.PaymentAmount > 0 THEN
        UPDATE Payment
        SET PaymentStatus = 'Completed'
        WHERE PaymentID = NEW.PaymentID;
    END IF;
END //

DELIMITER ;

SET GLOBAL event_scheduler = ON;

CREATE EVENT remind_participants
ON SCHEDULE EVERY 1 DAY
DO
    UPDATE Event
    SET EventStatus = 'Upcoming'
    WHERE StartDateTime > NOW()
      AND EventStatus != 'Upcoming';

CREATE USER 'adminUser'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON dbProject.* TO 'adminUser'@'localhost';
FLUSH PRIVILEGES;

CREATE USER 'organizerUser'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT, INSERT, UPDATE ON dbProject.* TO 'organizerUser'@'localhost';

CREATE USER 'participantUser'@'localhost' IDENTIFIED BY 'password123';
GRANT SELECT ON dbProject.* TO 'participantUser'@'localhost';

CREATE USER 'judgeUser'@'localhost' IDENTIFIED BY 'password123';
-- Allow judge to read Events
GRANT SELECT ON dbProject.Event TO 'judgeUser'@'localhost';

-- Allow judge to insert scores
GRANT SELECT, INSERT, UPDATE ON dbProject.Score TO 'judgeUser'@'localhost';

-- (Optional) Allow judge to see participant names (optional)
GRANT SELECT ON dbProject.User TO 'judgeUser'@'localhost';

-- Apply the permissions
FLUSH PRIVILEGES;



select * from user;