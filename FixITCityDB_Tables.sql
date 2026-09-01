-- ============================================
-- FIXITCITY DATABASE - FIREBASE READY
-- SQL Server / SSMS syntax
-- Version: 2.0 (Firebase Integration)
-- ============================================

-- ============================================
-- DROP TABLES (if they exist - reverse order)
-- ============================================
IF OBJECT_ID('DeviceTokens', 'U') IS NOT NULL DROP TABLE DeviceTokens;
IF OBJECT_ID('AuditLogs', 'U') IS NOT NULL DROP TABLE AuditLogs;
IF OBJECT_ID('Notifications', 'U') IS NOT NULL DROP TABLE Notifications;
IF OBJECT_ID('ReportFeedback', 'U') IS NOT NULL DROP TABLE ReportFeedback;
IF OBJECT_ID('FaultStatusHistory', 'U') IS NOT NULL DROP TABLE FaultStatusHistory;
IF OBJECT_ID('PriorityScores', 'U') IS NOT NULL DROP TABLE PriorityScores;
IF OBJECT_ID('DuplicateReports', 'U') IS NOT NULL DROP TABLE DuplicateReports;
IF OBJECT_ID('ReportPhotos', 'U') IS NOT NULL DROP TABLE ReportPhotos;
IF OBJECT_ID('FaultReports', 'U') IS NOT NULL DROP TABLE FaultReports;
IF OBJECT_ID('ServiceAreas', 'U') IS NOT NULL DROP TABLE ServiceAreas;
IF OBJECT_ID('EssentialServices', 'U') IS NOT NULL DROP TABLE EssentialServices;
IF OBJECT_ID('FaultCategories', 'U') IS NOT NULL DROP TABLE FaultCategories;
IF OBJECT_ID('MunicipalUsers', 'U') IS NOT NULL DROP TABLE MunicipalUsers;
IF OBJECT_ID('CitizenProfiles', 'U') IS NOT NULL DROP TABLE CitizenProfiles;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO

-- ============================================
-- TABLE 1: Users (Firebase Auth Ready)
-- ============================================
IF OBJECT_ID('Users', 'U') IS NULL
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NULL,  -- Can be NULL if using Firebase Auth only
    firebase_uid VARCHAR(128) NULL,   -- Firebase Authentication UID
    role VARCHAR(20) NOT NULL DEFAULT 'Citizen' CHECK (role IN ('Citizen', 'Municipal')),
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME NULL,
    updated_at DATETIME NULL
);

CREATE INDEX IX_Users_Email ON Users(email);
CREATE INDEX IX_Users_FirebaseUID ON Users(firebase_uid);
CREATE INDEX IX_Users_Role ON Users(role);
GO

-- ============================================
-- TABLE 2: CitizenProfiles
-- ============================================
IF OBJECT_ID('CitizenProfiles', 'U') IS NULL
CREATE TABLE CitizenProfiles (
    citizen_profile_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NULL,
    address_line VARCHAR(255) NULL,
    city VARCHAR(100) NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    notification_preference VARCHAR(20) DEFAULT 'Email',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE INDEX IX_CitizenProfiles_UserID ON CitizenProfiles(user_id);
GO

-- ============================================
-- TABLE 3: MunicipalUsers (Admins only)
-- ============================================
IF OBJECT_ID('MunicipalUsers', 'U') IS NULL
CREATE TABLE MunicipalUsers (
    municipal_user_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    employee_id VARCHAR(50) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    position_title VARCHAR(100) NOT NULL,
    hire_date DATE NOT NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE INDEX IX_MunicipalUsers_UserID ON MunicipalUsers(user_id);
CREATE INDEX IX_MunicipalUsers_EmployeeID ON MunicipalUsers(employee_id);
GO

-- ============================================
-- TABLE 4: FaultCategories
-- ============================================
IF OBJECT_ID('FaultCategories', 'U') IS NULL
CREATE TABLE FaultCategories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255) NULL,
    severity_weight DECIMAL(4,2) NOT NULL CHECK (severity_weight BETWEEN 1 AND 10),
    estimated_fix_time INT NULL,  -- in hours
    icon VARCHAR(50) NULL,
    is_active BIT DEFAULT 1
);
GO

-- ============================================
-- TABLE 5: EssentialServices
-- ============================================
IF OBJECT_ID('EssentialServices', 'U') IS NULL
CREATE TABLE EssentialServices (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    service_type VARCHAR(50) NOT NULL CHECK (service_type IN ('School', 'Clinic', 'Hospital', 'Police', 'Fire Station')),
    address_line VARCHAR(255) NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    ward_number VARCHAR(10) NULL,
    contact_number VARCHAR(20) NULL
);

CREATE INDEX IX_EssentialServices_LatLong ON EssentialServices(latitude, longitude);
CREATE INDEX IX_EssentialServices_ServiceType ON EssentialServices(service_type);
GO

-- ============================================
-- TABLE 6: ServiceAreas
-- ============================================
IF OBJECT_ID('ServiceAreas', 'U') IS NULL
CREATE TABLE ServiceAreas (
    area_id INT IDENTITY(1,1) PRIMARY KEY,
    area_name VARCHAR(50) NOT NULL UNIQUE,
    ward_number VARCHAR(10) NOT NULL,
    description VARCHAR(255) NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

CREATE INDEX IX_ServiceAreas_WardNumber ON ServiceAreas(ward_number);
GO

-- ============================================
-- TABLE 7: FaultReports (Offline Support Ready)
-- ============================================
IF OBJECT_ID('FaultReports', 'U') IS NULL
CREATE TABLE FaultReports (
    report_id INT IDENTITY(1,1) PRIMARY KEY,
    citizen_id INT NOT NULL,
    category_id INT NOT NULL,
    area_id INT NULL,
    title VARCHAR(200) NOT NULL,
    description VARCHAR(1000) NOT NULL,
    latitude DECIMAL(10,7) NOT NULL,
    longitude DECIMAL(10,7) NOT NULL,
    address_line VARCHAR(255) NULL,
    status VARCHAR(30) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Verified', 'InProgress', 'Resolved', 'Rejected')),
    priority_score INT NULL CHECK (priority_score BETWEEN 0 AND 100),
    reference_number VARCHAR(20) NOT NULL UNIQUE,
    verified_by INT NULL,
    verified_at DATETIME NULL,
    assigned_to INT NULL,
    resolution_notes VARCHAR(500) NULL,
    resolved_at DATETIME NULL,
    is_duplicate BIT DEFAULT 0,
    -- OFFLINE SUPPORT COLUMNS
    is_offline BIT DEFAULT 0,
    sync_status VARCHAR(20) DEFAULT 'Synced' CHECK (sync_status IN ('Pending', 'Synced', 'Failed')),
    offline_id VARCHAR(50) NULL,  -- Temporary ID generated offline
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    FOREIGN KEY (citizen_id) REFERENCES CitizenProfiles(citizen_profile_id),
    FOREIGN KEY (category_id) REFERENCES FaultCategories(category_id),
    FOREIGN KEY (area_id) REFERENCES ServiceAreas(area_id),
    FOREIGN KEY (verified_by) REFERENCES MunicipalUsers(municipal_user_id),
    FOREIGN KEY (assigned_to) REFERENCES MunicipalUsers(municipal_user_id)
);

CREATE INDEX IX_FaultReports_CitizenID ON FaultReports(citizen_id);
CREATE INDEX IX_FaultReports_CategoryID ON FaultReports(category_id);
CREATE INDEX IX_FaultReports_AreaID ON FaultReports(area_id);
CREATE INDEX IX_FaultReports_Status ON FaultReports(status);
CREATE INDEX IX_FaultReports_CreatedAt ON FaultReports(created_at);
CREATE INDEX IX_FaultReports_PriorityScore ON FaultReports(priority_score);
CREATE INDEX IX_FaultReports_LatLong ON FaultReports(latitude, longitude);
CREATE INDEX IX_FaultReports_SyncStatus ON FaultReports(sync_status);
GO

-- ============================================
-- TABLE 8: ReportPhotos (Offline Support Ready)
-- ============================================
IF OBJECT_ID('ReportPhotos', 'U') IS NULL
CREATE TABLE ReportPhotos (
    photo_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL,
    photo_url VARCHAR(500) NOT NULL,  -- Firebase Storage URL
    firebase_storage_path VARCHAR(500) NULL,  -- Firebase Storage path
    is_primary BIT DEFAULT 0,
    -- OFFLINE SUPPORT COLUMNS
    is_offline BIT DEFAULT 0,
    sync_status VARCHAR(20) DEFAULT 'Synced' CHECK (sync_status IN ('Pending', 'Synced', 'Failed')),
    offline_photo_path VARCHAR(500) NULL,  -- Local file path when offline
    uploaded_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id)
);

CREATE INDEX IX_ReportPhotos_ReportID ON ReportPhotos(report_id);
GO

-- ============================================
-- TABLE 9: DuplicateReports
-- ============================================
IF OBJECT_ID('DuplicateReports', 'U') IS NULL
CREATE TABLE DuplicateReports (
    duplicate_link_id INT IDENTITY(1,1) PRIMARY KEY,
    original_report_id INT NOT NULL,
    duplicate_report_id INT NOT NULL,
    match_percentage DECIMAL(5,2) NOT NULL,
    marked_by INT NULL,
    marked_at DATETIME DEFAULT GETDATE(),
    is_merged BIT DEFAULT 0,
    FOREIGN KEY (original_report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (duplicate_report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (marked_by) REFERENCES MunicipalUsers(municipal_user_id),
    CONSTRAINT CHK_DifferentReports CHECK (original_report_id != duplicate_report_id)
);

CREATE INDEX IX_DuplicateReports_Original ON DuplicateReports(original_report_id);
CREATE INDEX IX_DuplicateReports_Duplicate ON DuplicateReports(duplicate_report_id);
GO

-- ============================================
-- TABLE 10: PriorityScores
-- ============================================
IF OBJECT_ID('PriorityScores', 'U') IS NULL
CREATE TABLE PriorityScores (
    score_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL UNIQUE,
    total_score DECIMAL(6,2) NOT NULL CHECK (total_score BETWEEN 0 AND 100),
    severity_factor DECIMAL(6,2) NOT NULL CHECK (severity_factor BETWEEN 0 AND 25),
    proximity_factor DECIMAL(6,2) NOT NULL CHECK (proximity_factor BETWEEN 0 AND 35),
    duplicate_factor DECIMAL(6,2) NOT NULL CHECK (duplicate_factor BETWEEN 0 AND 20),
    age_factor DECIMAL(6,2) NOT NULL CHECK (age_factor BETWEEN 0 AND 20),
    computed_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id)
);

CREATE INDEX IX_PriorityScores_ReportID ON PriorityScores(report_id);
CREATE INDEX IX_PriorityScores_TotalScore ON PriorityScores(total_score);
GO

-- ============================================
-- TABLE 11: FaultStatusHistory
-- ============================================
IF OBJECT_ID('FaultStatusHistory', 'U') IS NULL
CREATE TABLE FaultStatusHistory (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL,
    old_status VARCHAR(30) NULL,
    new_status VARCHAR(30) NOT NULL,
    changed_by INT NOT NULL,
    changed_at DATETIME DEFAULT GETDATE(),
    notes VARCHAR(255) NULL,
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (changed_by) REFERENCES MunicipalUsers(municipal_user_id)
);

CREATE INDEX IX_FaultStatusHistory_ReportID ON FaultStatusHistory(report_id);
CREATE INDEX IX_FaultStatusHistory_ChangedAt ON FaultStatusHistory(changed_at);
GO

-- ============================================
-- TABLE 12: ReportFeedback
-- ============================================
IF OBJECT_ID('ReportFeedback', 'U') IS NULL
CREATE TABLE ReportFeedback (
    feedback_id INT IDENTITY(1,1) PRIMARY KEY,
    report_id INT NOT NULL UNIQUE,
    citizen_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment VARCHAR(500) NULL,
    response_time INT NULL,  -- Days to resolve
    is_anonymous BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME NULL,
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id),
    FOREIGN KEY (citizen_id) REFERENCES CitizenProfiles(citizen_profile_id)
);

CREATE INDEX IX_ReportFeedback_ReportID ON ReportFeedback(report_id);
CREATE INDEX IX_ReportFeedback_CitizenID ON ReportFeedback(citizen_id);
CREATE INDEX IX_ReportFeedback_Rating ON ReportFeedback(rating);
GO

-- ============================================
-- TABLE 13: Notifications (FCM Ready)
-- ============================================
IF OBJECT_ID('Notifications', 'U') IS NULL
CREATE TABLE Notifications (
    notification_id INT IDENTITY(1,1) PRIMARY KEY,
    citizen_id INT NOT NULL,
    report_id INT NULL,
    notification_type VARCHAR(50) CHECK (notification_type IN ('StatusUpdate', 'Assignment', 'Reminder', 'Alert')),
    channel VARCHAR(20) CHECK (channel IN ('SMS', 'Push')),
    subject VARCHAR(200) NOT NULL,
    message VARCHAR(500) NOT NULL,
    -- FCM SPECIFIC COLUMNS
    device_token VARCHAR(255) NULL,  -- FCM device token
    fcm_message_id VARCHAR(100) NULL,  -- FCM response ID
    is_sent BIT DEFAULT 0,
    sent_at DATETIME NULL,
    is_read BIT DEFAULT 0,
    read_at DATETIME NULL,
    is_delivered BIT DEFAULT 0,
    delivered_at DATETIME NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (citizen_id) REFERENCES CitizenProfiles(citizen_profile_id),
    FOREIGN KEY (report_id) REFERENCES FaultReports(report_id)
);

CREATE INDEX IX_Notifications_CitizenID ON Notifications(citizen_id);
CREATE INDEX IX_Notifications_ReportID ON Notifications(report_id);
CREATE INDEX IX_Notifications_IsRead ON Notifications(is_read);
CREATE INDEX IX_Notifications_IsSent ON Notifications(is_sent);
GO

-- ============================================
-- TABLE 14: AuditLogs
-- ============================================
IF OBJECT_ID('AuditLogs', 'U') IS NULL
CREATE TABLE AuditLogs (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    municipal_user_id INT NOT NULL,
    action VARCHAR(100) NOT NULL,
    table_affected VARCHAR(100) NOT NULL,
    record_id INT NOT NULL,
    old_values VARCHAR(MAX) NULL,
    new_values VARCHAR(MAX) NULL,
    ip_address VARCHAR(45) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (municipal_user_id) REFERENCES MunicipalUsers(municipal_user_id)
);

CREATE INDEX IX_AuditLogs_MunicipalUserID ON AuditLogs(municipal_user_id);
CREATE INDEX IX_AuditLogs_CreatedAt ON AuditLogs(created_at);
GO

-- ============================================
-- TABLE 15: DeviceTokens (NEW - For FCM)
-- ============================================
IF OBJECT_ID('DeviceTokens', 'U') IS NULL
CREATE TABLE DeviceTokens (
    token_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    device_token VARCHAR(255) NOT NULL UNIQUE,
    device_type VARCHAR(20) NOT NULL CHECK (device_type IN ('Android', 'Web')),
    device_name VARCHAR(100) NULL,
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    last_used_at DATETIME NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE INDEX IX_DeviceTokens_UserID ON DeviceTokens(user_id);
CREATE INDEX IX_DeviceTokens_Token ON DeviceTokens(device_token);
CREATE INDEX IX_DeviceTokens_IsActive ON DeviceTokens(is_active);

-- ============================================
-- FUNCTION: Generate Report Reference Number
-- ============================================
IF OBJECT_ID('sp_GenerateReportId', 'P') IS NOT NULL
    DROP PROCEDURE sp_GenerateReportId;
GO

CREATE PROCEDURE sp_GenerateReportId
    @ReferenceNumber VARCHAR(20) OUTPUT
AS
BEGIN
    DECLARE @Random INT = ABS(CHECKSUM(NEWID())) % 10000;
    SET @ReferenceNumber = 'FIX-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + 
                           RIGHT('0000' + CAST(@Random AS VARCHAR(4)), 4);
END;

