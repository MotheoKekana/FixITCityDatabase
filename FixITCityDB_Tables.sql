-- ============================================
-- CREATE ALL TABLES
-- ============================================

-- 1. Users
IF OBJECT_ID('Users', 'U') IS NULL
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(255),
    password_hash VARCHAR(255),
    role VARCHAR(20),
    created_at DATETIME
);

-- 2. CitizenProfiles
IF OBJECT_ID('CitizenProfiles', 'U') IS NULL
CREATE TABLE CitizenProfiles (
    citizen_profile_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone_number VARCHAR(20),
    address_line VARCHAR(255),
    city VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 3. MunicipalUsers
IF OBJECT_ID('MunicipalUsers', 'U') IS NULL
CREATE TABLE MunicipalUsers (
    municipal_user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    department VARCHAR(100),
    position_title VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 4. FaultCategories
IF OBJECT_ID('FaultCategories', 'U') IS NULL
CREATE TABLE FaultCategories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(255),
    severity_weight DECIMAL(4,2)
);

-- 5. EssentialServices
IF OBJECT_ID('EssentialServices', 'U') IS NULL
CREATE TABLE EssentialServices (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255),
    service_type VARCHAR(50),
    address_line VARCHAR(255),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- 6. ServiceAreas 
IF OBJECT_ID('ServiceAreas', 'U') IS NULL
CREATE TABLE ServiceAreas (
    area_id INT IDENTITY(1,1) PRIMARY KEY,
    area_name VARCHAR(50),
    ward_number VARCHAR(10),
    description VARCHAR(255),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6)
);

-- 7. FaultReports (with area_id and resolved_at)
IF OBJECT_ID('FaultReports', 'U') IS NULL
CREATE TABLE FaultReports (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    citizen_id INT,
    category_id INT,
    area_id INT,
    title VARCHAR(200),
    description VARCHAR(1000),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    status VARCHAR(30),
    assigned_to INT,
    created_at DATETIME,
    resolved_at DATETIME,
    FOREIGN KEY (citizen_id) REFERENCES CitizenProfiles(citizen_profile_id),
    FOREIGN KEY (category_id) REFERENCES FaultCategories(category_id),
    FOREIGN KEY (area_id) REFERENCES ServiceAreas(area_id),
    FOREIGN KEY (assigned_to) REFERENCES MunicipalUsers(municipal_user_id)
);

-- 8. ReportPhotos
IF OBJECT_ID('ReportPhotos', 'U') IS NULL
CREATE TABLE ReportPhotos (
    photo_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT,
    photo_url VARCHAR(500),
    uploaded_at DATETIME,
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id)
);

-- 9. DuplicateReports
IF OBJECT_ID('DuplicateReports', 'U') IS NULL
CREATE TABLE DuplicateReports (
    duplicate_link_id INT IDENTITY(1,1) PRIMARY KEY,
    original_report_id INT,
    duplicate_report_id INT,
    marked_by INT,
    marked_at DATETIME,
    FOREIGN KEY (original_report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (duplicate_report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (marked_by) REFERENCES MunicipalUsers(municipal_user_id)
);

-- 10. PriorityScores
IF OBJECT_ID('PriorityScores', 'U') IS NULL
CREATE TABLE PriorityScores (
    score_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT,
    total_score DECIMAL(6,2),
    severity_factor DECIMAL(6,2),
    proximity_factor DECIMAL(6,2),
    duplicate_factor DECIMAL(6,2),
    age_factor DECIMAL(6,2),
    computed_at DATETIME,
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id)
);

-- 11. FaultStatusHistory (with notes)
IF OBJECT_ID('FaultStatusHistory', 'U') IS NULL
CREATE TABLE FaultStatusHistory (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT,
    old_status VARCHAR(30),
    new_status VARCHAR(30),
    changed_by INT,
    changed_at DATETIME,
    notes VARCHAR(255),
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (changed_by) REFERENCES MunicipalUsers(municipal_user_id)
);

-- 12. ReportFeedback 
IF OBJECT_ID('ReportFeedback', 'U') IS NULL
CREATE TABLE ReportFeedback (
    feedback_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT,
    citizen_id INT,
    rating INT,
    comment VARCHAR(500),
    created_at DATETIME,
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (citizen_id) REFERENCES CitizenProfiles(citizen_profile_id)
);

-- 13. Notifications
IF OBJECT_ID('Notifications', 'U') IS NULL
CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    citizen_id INT,
    report_id INT,
    channel VARCHAR(20),
    message VARCHAR(500),
    sent_at DATETIME,
    read_at DATETIME,
    FOREIGN KEY (citizen_id) REFERENCES CitizenProfiles(citizen_profile_id),
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id)
);

-- 14. AuditLogs
IF OBJECT_ID('AuditLogs', 'U') IS NULL
CREATE TABLE AuditLogs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    municipal_user_id INT,
    action VARCHAR(100),
    table_affected VARCHAR(100),
    record_id INT,
    created_at DATETIME,
    FOREIGN KEY (municipal_user_id) REFERENCES MunicipalUsers(municipal_user_id)
);


-- ============================================
-- SEED REFERENCE DATA
-- ============================================

INSERT INTO FaultCategories (name, description, severity_weight)
VALUES 
('Burst Pipe', 'Water pipe burst', 10),
('Pothole', 'Road damage', 7),
('Streetlight Outage', 'Streetlight not working', 4),
('Electrical Outage', 'No electricity', 8),
('Sewage Leak', 'Sewage overflow', 9),
('Pavement Crack', 'Cracked pavement', 2),
('Fallen Tree', 'Tree across road', 6),
('Traffic Light Outage', 'Traffic signals not working', 7),
('Water Contamination', 'Contaminated water', 9),
('Road Marker Damage', 'Damaged road signs', 3),
('Illegal Dumping', 'Illegally dumped waste or rubble', 4);

INSERT INTO EssentialServices (name, service_type, address_line, latitude, longitude) VALUES
('Pearson High School',            'SCHOOL',   'La Roche Drive, Humewood',        -33.97400, 25.65200),
('Grey High School',               'SCHOOL',   'Park Drive, Central',             -33.95560, 25.59310),
('Alexander Road High School',     'SCHOOL',   'Rochelle Street, Walmer',         -33.99320, 25.60960),
('Charter House School',           'SCHOOL',   '2nd Avenue, Summerstrand',        -33.98720, 25.66850),
('Framesby High School',           'SCHOOL',   'Kragga Kamma Road, Greenacres',   -33.95400, 25.58500),
('Livingstone Hospital',           'HOSPITAL', 'Stanford Road, Central',          -33.94350, 25.59750),
('Life St George''s Hospital',     'HOSPITAL', 'Rochester Road, Central',         -33.94940, 25.58670),
('Greenacres Clinic',              'CLINIC',   'Ring Road, Greenacres',           -33.95050, 25.58950),
('Walmer Community Health Centre', 'CLINIC',   'Main Road, Walmer',               -33.99600, 25.60750),
('Humewood Medical Centre',        'CLINIC',   'Beach Road, Humewood',            -33.97250, 25.64800);

INSERT INTO ServiceAreas (area_name, ward_number, description, latitude, longitude) VALUES
('Summerstrand', 'Ward 3',  'Coastal suburb, beachfront and hotel district',       -33.98550, 25.67100),
('Humewood',     'Ward 3',  'Beachfront suburb near the Boardwalk precinct',       -33.97350, 25.64950),
('Central',      'Ward 5',  'City centre, government and commercial hub',          -33.95950, 25.60300),
('Walmer',       'Ward 7',  'Residential suburb south of the city centre',         -33.99500, 25.60800),
('Greenacres',   'Ward 9',  'Residential and retail suburb near Cape Road',        -33.95150, 25.59050);

PRINT '✅ Reference data seeded!';
GO

-- ============================================
-- SEED TEST DATA
-- ============================================

INSERT INTO Users (email, password_hash, role, created_at)
VALUES 
('admin@fixitcity.com', 'hashed_admin_pass', 'Municipal', GETDATE()),
('s229237754@mandela.ac.za', 'hashed_pass_1', 'Citizen', GETDATE()),
('s229818994@mandela.ac.za', 'hashed_pass_2', 'Citizen', GETDATE()),
('s229785689@mandela.ac.za', 'hashed_pass_3', 'Citizen', GETDATE());

INSERT INTO MunicipalUsers (user_id, department, position_title)
VALUES (1, 'Port Elizabeth Municipal Services', 'System Administrator');

INSERT INTO CitizenProfiles (user_id, first_name, last_name, phone_number, address_line, city, latitude, longitude)
VALUES 
(2, 'Motheo', 'Kekana', '+27-82-123-4567', '123 Main Rd', 'Central', -33.9608, 25.6022),
(3, 'Malik', 'Ndayisaba', '+27-82-234-5678', '456 7th Ave', 'Walmer', -33.9817, 25.5840),
(4, 'Cohen', 'Geswint', '+27-82-345-6789', '789 Cape Rd', 'Newton Park', -33.9644, 25.5627);

-- Report 1: Burst pipe in Central (Pending)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    1, 1, 3, 
    'Burst Pipe on Main Road', 
    'Water pipe burst on Main Road near the Post Office. Water flooding the street.', 
    -33.9610, 25.6030, 
    'Pending', 
    GETDATE()
);

-- Report 2: Pothole in Walmer (Verified)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    2, 2, 4, 
    'Large Pothole on 8th Avenue', 
    'Large pothole on 8th Avenue near the Walmer Police Station. Dangerous for vehicles.', 
    -33.9825, 25.5915, 
    'Verified', 
    DATEADD(HOUR, -2, GETDATE())
);

-- Report 3: Electrical outage in Newton Park (InProgress)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    3, 4, 5, 
    'Power Outage on Cape Road', 
    'No electricity on Cape Road near Greenacres. Outage for the past 4 hours.', 
    -33.9650, 25.5750, 
    'InProgress', 
    DATEADD(HOUR, -5, GETDATE())
);

-- Report 4: Sewage leak in North End (Pending)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    1, 5, 2, 
    'Sewage Leak on North End Road', 
    'Sewage overflowing from manhole on North End Road near the factory area.', 
    -33.9480, 25.6180, 
    'Pending', 
    DATEADD(HOUR, -1, GETDATE())
);

-- Report 5: Fallen tree in South End (Verified)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    2, 7, 3, 
    'Fallen Tree on Beach Road', 
    'Large tree fallen across Beach Road near Humewood. Blocking traffic.', 
    -33.9780, 25.6420, 
    'Verified', 
    DATEADD(HOUR, -8, GETDATE())
);

-- Report 6: Traffic light outage (Pending)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    3, 8, 1, 
    'Traffic Light Not Working on Govan Mbeki', 
    'Traffic lights at Govan Mbeki and Russel Road intersection are dead.', 
    -33.9630, 25.6180, 
    'Pending', 
    DATEADD(HOUR, -3, GETDATE())
);

-- Report 7: Streetlight outage (Verified)
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    1, 3, 4, 
    'Streetlights Out on Main Road', 
    'Streetlights on Main Road between 6th and 10th Avenue are not working.', 
    -33.9820, 25.5900, 
    'Verified', 
    DATEADD(HOUR, -12, GETDATE())
);

-- Report 8: Resolved report
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at, resolved_at)
VALUES (
    2, 6, 5, 
    'Pavement Crack on Cape Road', 
    'Large crack in pavement on Cape Road. Trip hazard.', 
    -33.9660, 25.5730, 
    'Resolved', 
    DATEADD(DAY, -3, GETDATE()),
    DATEADD(DAY, -1, GETDATE())
);

-- Report 9: Rejected report
INSERT INTO FaultReports (citizen_id, category_id, area_id, title, description, latitude, longitude, status, created_at)
VALUES (
    3, 10, 3, 
    'Road Marker Damaged', 
    'Road sign damaged on Beach Road near the Boardwalk.', 
    -33.9790, 25.6380, 
    'Rejected', 
    DATEADD(DAY, -2, GETDATE())
);

INSERT INTO ReportPhotos (report_id, photo_url, uploaded_at)
VALUES 
(1, '/uploads/report_1_photo1.jpg', GETDATE()),
(1, '/uploads/report_1_photo2.jpg', GETDATE()),
(2, '/uploads/report_2_photo1.jpg', GETDATE()),
(3, '/uploads/report_3_photo1.jpg', GETDATE()),
(4, '/uploads/report_4_photo1.jpg', GETDATE());

INSERT INTO PriorityScores (report_id, total_score, severity_factor, proximity_factor, duplicate_factor, age_factor)
VALUES 
(1, 80.0, 25.0, 30.0, 5.0, 20.0),
(2, 70.0, 20.0, 25.0, 10.0, 15.0),
(3, 65.0, 22.0, 20.0, 5.0, 18.0),
(4, 85.0, 23.0, 32.0, 10.0, 20.0),
(5, 60.0, 18.0, 22.0, 5.0, 15.0),
(6, 55.0, 15.0, 20.0, 5.0, 15.0),
(7, 50.0, 10.0, 25.0, 0.0, 15.0),
(8, 45.0, 5.0, 20.0, 0.0, 20.0),
(9, 30.0, 5.0, 15.0, 0.0, 10.0);

INSERT INTO FaultStatusHistory (report_id, old_status, new_status, changed_by, changed_at, notes)
VALUES 
(2, 'Pending', 'Verified', 1, DATEADD(HOUR, -3, GETDATE()), 'Verified by admin'),
(2, 'Verified', 'InProgress', 1, DATEADD(HOUR, -2, GETDATE()), 'Assigned to road team'),
(3, 'Pending', 'Verified', 1, DATEADD(HOUR, -4, GETDATE()), 'Verified by admin'),
(3, 'Verified', 'InProgress', 1, DATEADD(HOUR, -3, GETDATE()), 'Assigned to electrical team'),
(5, 'Pending', 'Verified', 1, DATEADD(HOUR, -6, GETDATE()), 'Verified by admin'),
(7, 'Pending', 'Verified', 1, DATEADD(HOUR, -10, GETDATE()), 'Verified by admin'),
(8, 'Pending', 'Verified', 1, DATEADD(DAY, -3, GETDATE()), 'Verified by admin'),
(8, 'Verified', 'InProgress', 1, DATEADD(DAY, -2, GETDATE()), 'Assigned to team'),
(8, 'InProgress', 'Resolved', 1, DATEADD(DAY, -1, GETDATE()), 'Pavement repaired'),
(9, 'Pending', 'Rejected', 1, DATEADD(DAY, -2, GETDATE()), 'Not municipal responsibility');

INSERT INTO ReportFeedback (report_id, citizen_id, rating, comment, created_at)
VALUES 
(2, 2, 4, 'Verified quickly. Waiting for repair.', DATEADD(DAY, -1, GETDATE())),
(3, 3, 5, 'Power restored in 6 hours. Excellent!', DATEADD(DAY, -2, GETDATE())),
(8, 2, 4, 'Pavement repaired within 2 days. Good work.', DATEADD(DAY, -1, GETDATE()));

INSERT INTO Notifications (citizen_id, report_id, channel, message, sent_at, read_at)
VALUES 
(2, 2, 'SMS', 'Your pothole report has been verified.', DATEADD(HOUR, -3, GETDATE()), DATEADD(HOUR, -2, GETDATE())),
(2, 2, 'SMS', 'Your pothole report is now InProgress.', DATEADD(HOUR, -2, GETDATE()), NULL),
(3, 3, 'SMS', 'Your power outage report has been verified.', DATEADD(HOUR, -4, GETDATE()), DATEADD(HOUR, -3, GETDATE())),
(3, 3, 'SMS', 'Your power outage report is now InProgress.', DATEADD(HOUR, -3, GETDATE()), NULL),
(1, 1, 'SMS', 'Your burst pipe report has been received.', DATEADD(HOUR, -2, GETDATE()), NULL),
(1, 4, 'SMS', 'Your sewage leak report has been received.', DATEADD(HOUR, -1, GETDATE()), NULL),
(2, 5, 'SMS', 'Your fallen tree report has been verified.', DATEADD(HOUR, -6, GETDATE()), NULL);

INSERT INTO DuplicateReports (original_report_id, duplicate_report_id, marked_by, marked_at)
VALUES (1, 6, 1, GETDATE());

INSERT INTO AuditLogs (municipal_user_id, action, table_affected, record_id, created_at)
VALUES 
(1, 'Verify Report', 'FaultReports', 2, DATEADD(HOUR, -3, GETDATE())),
(1, 'Update Status', 'FaultReports', 2, DATEADD(HOUR, -2, GETDATE())),
(1, 'Verify Report', 'FaultReports', 3, DATEADD(HOUR, -4, GETDATE())),
(1, 'Update Status', 'FaultReports', 3, DATEADD(HOUR, -3, GETDATE())),
(1, 'Verify Report', 'FaultReports', 5, DATEADD(HOUR, -6, GETDATE())),
(1, 'Verify Report', 'FaultReports', 7, DATEADD(HOUR, -10, GETDATE())),
(1, 'Resolve Report', 'FaultReports', 8, DATEADD(DAY, -1, GETDATE())),
(1, 'Reject Report', 'FaultReports', 9, DATEADD(DAY, -2, GETDATE()));
