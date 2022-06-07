-- DATABASE TYPES --------------------------------------------------------
CREATE TABLE userTypes (-- The types of users could be ADMIN, PARTNER,TRAINER,CUSTOMER
    typeID SERIAL PRIMARY KEY,
    typeName VARCHAR(15) NOT NULL,
    typeDescription VARCHAR(50) NOT NULL 
);
CREATE TABLE memberShipType ( -- Types to show type of access and benefits
    memberShipTypeId SERIAL PRIMARY KEY,
    memberShipTitle VARCHAR(20) NOT NULL, -- Gold , silver, bronze etc.
    memberShipDescription VARCHAR(50) NOT NULL,
    memberShipDuration SMALLINT NOT NULL -- Documents in days how long their membership lasts.
);
CREATE TABLE challengeCategories (-- The types of challenges. FITNESS,FUN,EXTREME FITNESS
    id SERIAL PRIMARY KEY,
    typeName VARCHAR(15) NOT NULL,
    typeDescription VARCHAR(50) NOT NULL 
);
CREATE TABLE exerciseAppearance ( -- Internal table for shows or no shows
    appearanceId BOOLEAN PRIMARY KEY NOT NULL,
    appearanceTitle VARCHAR(8)
);
CREATE TABLE profileType ( -- Public or private
    id SMALLINT PRIMARY KEY NOT NULL,
    theDescription VARCHAR(15) NOT NULL
);
-- USERS ----------------------------------------------------------
CREATE TABLE partnerDetails (-- partnership details
    id SERIAL PRIMARY KEY,
    abn VARCHAR(15),
    companyName VARCHAR(60) NOT NULL,
    companyAddress1 VARCHAR(100),
    companyAddress2 VARCHAR(100),
    companyPCode SMALLINT ,
    contact_number VARCHAR(20),
    dateJoined DATE,
    CONSTRAINT validate_user_pcode CHECK (companyPCode >=800 AND companyPCode <8000)
);
CREATE TABLE users ( -- All users that have access to Login
    email TEXT UNIQUE,
    id SERIAL PRIMARY KEY,
    userType SMALLINT REFERENCES userTypes(typeID) NOT NULL,
    profileType SMALLINT REFERENCES profileType(id) NOT NULL,
    memberShipType SMALLINT REFERENCES memberShipType(memberShipTypeId) NOT NULL,
    memberShipStartDate DATE NOT NULL, -- The date their membership started
    memberShipStartTime TIMESTAMP,
    partnerDetails SMALLINT REFERENCES partnerDetails(id), -- Only required if the user is of TYPE PARTNER
    partnerId SMALLINT REFERENCES users(id), -- The partner this user belongs to
    title VARCHAR(8) NOT NULL ,
    firstName VARCHAR(20)NOT NULL ,
    lastName VARCHAR(30),
    gender VARCHAR(2),

    mobile VARCHAR(20),
    otherPhone VARCHAR(20),
    dateJoined DATE NOT NULL ,
    photo TEXT,
    userLevel SMALLINT,
    emergencyContactName VARCHAR(20),
    emergencyContactNumber VARCHAR(20),
    userBmi_begin FLOAT,
    userHeight FLOAT,
    userWeight FLOAT,
    userDob DATE,
    userPcode SMALLINT,
    CONSTRAINT validate_user_pcode CHECK (userPcode >=800 AND userPcode <8000),
    CONSTRAINT validate_email CHECK (email LIKE '%___@___%__%') ,
    reffereeCode VARCHAR(10), -- A unique Code for the user used by others when referring
    referedBy SMALLINT REFERENCES users(id),
    hashed_password TEXT NOT NULL
);
CREATE TABLE usersWeightLossHistory ( -- records all users weight loss journey
    userid SMALLINT REFERENCES users(id),
    dateEntered DATE NOT NULL,
    timeEntered TIMESTAMP,
    userComment TEXT,
    userWeight FLOAT NOT NULL
);
CREATE TABLE userReviews ( -- Users review of whole site
    dateOfReview DATE NOT NULL,
    userId SMALLINT REFERENCES users(id) NOT NULL,
    usersComment TEXT NOT NULL
);
-- CHALLENGES --------------------------------------------------------
CREATE TABLE challengeLevels ( -- the level of the challenges
    id SERIAL PRIMARY KEY,
    theTitle VARCHAR(20) NOT NULL,
    levelNumber SMALLINT NOT NULL  -- The difficulty level
);
CREATE TABLE challenges (-- All the potential challenges
    id SERIAL PRIMARY KEY,
    challengeCategory SMALLINT REFERENCES challengeCategories(id) NOT NULL,
    creationDate DATE NOT NULL,
    challengelevel SMALLINT REFERENCES challengeLevels(id) NOT NULL,
    theTitle VARCHAR(30) NOT NULL,
    theSubDescription VARCHAR(100) NOT NULL,
    theDescription TEXT NOT NULL,
    theRules TEXT NOT NULL,
    theLocation TEXT,
    photo TEXT,
    pointsValue SMALLINT NOT NULL,
    userRatings SMALLINT,
    likes SMALLINT,
    dislikes SMALLINT,
    icon TEXT
);
CREATE TABLE challengesBatches ( -- The collection of the challenges. Keeps all historical data
    batchID SERIAL PRIMARY KEY, -- a Number referencing the batch of challenges
    batchTitle VARCHAR(30) NOT NULL
);
CREATE TABLE currentChallenges (-- A list of all challenge batches
    batchID SMALLINT REFERENCES challengesBatches(batchID) NOT NULL,
    theChallengeID SMALLINT REFERENCES challenges(id) NOT NULL,
    specialNote TEXT,
    likes SMALLINT,
    dislikes SMALLINT,
    userRating SMALLINT,
    userPhoto TEXT
);
CREATE TABLE challengeAcknowledgments (-- Marks when the user has anckonwledged a challenge
    batchID SMALLINT REFERENCES challengesBatches(batchID) NOT NULL,
    theChallengeID SMALLINT REFERENCES challenges(id) NOT NULL,
    theUserID SMALLINT REFERENCES users(id) NOT NULL
);
CREATE TABLE challengeCompletions (-- Marks when the user has completed a challenge. This table gets archived.
    batchID SMALLINT REFERENCES challengesBatches(batchID) NOT NULL,
    theChallengeID SMALLINT REFERENCES challenges(id) NOT NULL,
    theUserID SMALLINT REFERENCES users(id) NOT NULL,
    dateCompleted DATE,
    userComment TEXT,
    videoLink TEXT,
    userRating SMALLINT,
    userPhoto TEXT    
);
CREATE TABLE challengeCompletionHistory ( -- The historical record of completed challenges
    batchID SMALLINT REFERENCES challengesBatches(batchID) NOT NULL,
    theChallengeID SMALLINT REFERENCES challenges(id) NOT NULL,
    theUserID SMALLINT REFERENCES users(id) NOT NULL,
    dateCompleted DATE NOT NULL,
    userComment TEXT,
    userRating SMALLINT,
    userPhoto TEXT
);
-- EXERCISES --------------------------------------------------------
CREATE TABLE groupExercises (-- details the group exercise training events
    id SERIAL PRIMARY KEY,
    createdByUser SMALLINT REFERENCES users(id) NOT NULL, -- persona who created this exercise
    challengeLevel SMALLINT NOT NULL,
    theTitle VARCHAR(30) NOT NULL,
    theSubDescription VARCHAR(50) NOT NULL,
    theDescription VARCHAR(200) NOT NULL,
    photo TEXT,
    geoLatitude DECIMAL(8,6),
    geoLongitude DECIMAL(9,6),
    likes SMALLINT,
    dislikes SMALLINT -- Collected dislikes by the users
);
CREATE TABLE routines (-- Entered by ADMIN 
    id SERIAL PRIMARY KEY,
    theTitle VARCHAR(20) NOT NULL,
    theDescription TEXT NOT NULL
);
CREATE TABLE exercises ( -- Entered by ADMIN 
    id SERIAL PRIMARY KEY,
    theTitle VARCHAR(20) NOT NULL,
    theDescription TEXT NOT NULL,
    defaultReps SMALLINT NOT NULL
);
CREATE TABLE routineExercises (
    id SERIAL PRIMARY KEY,
    routineId SMALLINT REFERENCES routines(id) NOT NULL,
    exerciseId SMALLINT REFERENCES exercises(id) NOT NULL
);


-- SERVICES --------------------------------------------------------
CREATE TABLE services ( -- All services possible
    serviceId SERIAL PRIMARY KEY,
    serviceTitle VARCHAR(30) NOT NULL,
    serviceDuration SMALLINT NOT NULL
);
CREATE TABLE servicesEntitlements (-- What memberships gets what services
    serviceId SMALLINT REFERENCES services(serviceId) NOT NULL,
    membershipType SMALLINT REFERENCES memberShipType(memberShipTypeId) NOT NULL
);
CREATE TABLE partnersServices (-- Partners and the services they allow
    partnerID SMALLINT REFERENCES partnerDetails(id) NOT NULL,
    serviceId SMALLINT REFERENCES services(serviceId) NOT NULL  
);
-- CALENDAR --------------------------------------------------------
CREATE TABLE calendar (-- All events and their dates, start times finish times
    id SERIAL PRIMARY KEY,
    dateOfEvent DATE NOT NULL,
    theEvent SMALLINT REFERENCES groupExercises(id) NOT NULL,
    timeStart TIME NOT NULL,
    timeFinish TIME NOT NULL,
    personalTrainer SMALLINT REFERENCES users(id),
    locationOfEvent VARCHAR(50) NOT NULL,
    statusOfEvent BOOLEAN NOT NULL, -- 0 = cancelled 1=ACTIVE
    descriptionOfEvent TEXT, -- Special instructions or extra details
    requirementsOfEvent TEXT, -- Special requirements (towels, gloves etc...)
    attending SMALLINT -- How many are attending the event.
);
CREATE TABLE calendarAttendance ( -- table to show who is attending the calendar events
    calendarEvent SMALLINT REFERENCES calendar(id) NOT NULL,
    userAttending SMALLINT REFERENCES users(id) NOT NULL,
    userAttended BOOLEAN REFERENCES exerciseAppearance(appearanceId) NOT NULL -- ADMIN only declaring wether the user showed up or not 0 = no show 1 = show
);
-- SYSTEM --------------------------------------------------------
CREATE TABLE logins ( -- Logs the logins
    userId SMALLINT REFERENCES users(id) NOT NULL,
    loginDate DATE NOT NULL,
    loginTime TIMESTAMP NOT NULL
);
-- FINANCIALS ----------------------------------------------------
CREATE TABLE membershipPayments (
    payentID SERIAL PRIMARY KEY,
    userId SMALLINT REFERENCES users(id) NOT NULL,
    paymentAmount FLOAT NOT NULL,
    datePaid DATE NOT NULL,
    membershipType SMALLINT REFERENCES membershipType(memberShipTypeId),
    partnerID SMALLINT REFERENCES partnerDetails(id)
);
-- WEBSITE ENHANCEMENTS -----------------------------------------------------------
CREATE TABLE randomQuotes (
    quote TEXT NOT NULL,
    author VARCHAR(30) NOT NULL
);
CREATE TABLE randomFitnessPics (-- Random FREE fitness pictures 
    picLink TEXT NOT NULL
);
CREATE TABLE youtubeVideos (-- fitness videos found on Youtube
    id SERIAL PRIMARY KEY,
    videoLink TEXT NOT NULL,
    videoDescription TEXT NOT NULL
);

