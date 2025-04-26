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




