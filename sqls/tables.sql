-- 1) HEAD
CREATE TABLE HEAD (
    HID        INT PRIMARY KEY,
    name       VARCHAR(100),
    contact    VARCHAR(100),
    department VARCHAR(100)
);

-- 2) USER
CREATE TABLE USER (
    UID           INT PRIMARY KEY,
    password      VARCHAR(255) NOT NULL,
    bits_id       VARCHAR(50),
    hostel_number INT
);

-- 3) INCHARGE
CREATE TABLE INCHARGE (
    IID         INT PRIMARY KEY,
    phone_no    VARCHAR(20),
    email       VARCHAR(100),
    name        VARCHAR(100),
    department  VARCHAR(100)
);

-- 4) EQUIPMENT
CREATE TABLE EQUIPMENT (
    EID             INT PRIMARY KEY,
    equipment_name  VARCHAR(100),
    location        VARCHAR(100),
    quantity        INT
);

-- 5) LOCATION
CREATE TABLE LOCATION (
    LID      INT PRIMARY KEY,
    name     VARCHAR(100),
    type     VARCHAR(50),
    capacity INT
);

-- 6) TIME_SLOT (Weak Entity Identified by LOCATION)
--    Composite PK: (timeslot_id, LID)
CREATE TABLE TIME_SLOT (
    timeslot_id INT,
    LID         INT,
    start_time  TIME NOT NULL,
    end_time    TIME NOT NULL,
    PRIMARY KEY (timeslot_id, LID),
    FOREIGN KEY (LID) REFERENCES LOCATION(LID)
);

-- 7) BOOKING
--    References TIME_SLOT via the composite (timeslot_id, LID),
--    also references USER (UID) & INCHARGE (IID) as shown in the diagram.
CREATE TABLE BOOKING (
    BID          INT PRIMARY KEY,
    status       VARCHAR(50),
    booking_time DATETIME,
    timeslot_id  INT,
    LID          INT,
    UID          INT,
    IID          INT,
    FOREIGN KEY (timeslot_id, LID) REFERENCES TIME_SLOT(timeslot_id, LID),
    FOREIGN KEY (UID)              REFERENCES USER(UID),
    FOREIGN KEY (IID)              REFERENCES INCHARGE(IID)
);

-- 8) BORROW_TRANSACTION
--    User (UID) borrows equipment (EID), managed by incharge (IID).
CREATE TABLE BORROW_TRANSACTION (
    TID         INT PRIMARY KEY,
    borrow_time DATETIME,
    return_time DATETIME,
    fine        DECIMAL(10,2),
    status      VARCHAR(50),
    UID         INT,
    EID         INT,
    IID         INT,
    FOREIGN KEY (UID) REFERENCES USER(UID),
    FOREIGN KEY (EID) REFERENCES EQUIPMENT(EID),
    FOREIGN KEY (IID) REFERENCES INCHARGE(IID)
);

-- 9) PURCHASE
--    Initiated by incharge (IID), approved by head (HID).
CREATE TABLE PURCHASE (
    PID             INT PRIMARY KEY,
    date            DATE,
    quantity        INT,
    equipment_name  VARCHAR(100),
    status          VARCHAR(50),
    IID             INT,
    HID             INT,
    FOREIGN KEY (IID) REFERENCES INCHARGE(IID),
    FOREIGN KEY (HID) REFERENCES HEAD(HID)
);