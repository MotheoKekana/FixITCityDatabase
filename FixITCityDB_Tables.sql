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
