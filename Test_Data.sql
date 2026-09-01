-- ============================================
-- FIXITCITY SEED DATA - FIREBASE READY
-- FIXED VERSION
-- ============================================

USE FixITCityDB;
GO

-- ============================================
-- SEED REFERENCE DATA
-- ============================================

-- 1. FaultCategories
INSERT INTO FaultCategories (name, description, severity_weight, estimated_fix_time, icon, is_active)
VALUES 
('Burst Pipe', 'Water pipe burst causing flooding or water loss', 10, 6, 'pipe', 1),
('Pothole', 'Road damage creating potholes', 7, 4, 'pothole', 1),
('Streetlight Outage', 'Streetlight not working', 4, 8, 'streetlight', 1),
('Electrical Outage', 'No electricity in an area', 8, 5, 'power', 1),
('Sewage Leak', 'Sewage system leak or overflow', 9, 12, 'sewage', 1),
('Pavement Crack', 'Cracked or damaged pavement', 2, 3, 'pavement', 1),
('Fallen Tree', 'Tree fallen across road or property', 6, 5, 'tree', 1),
('Traffic Light Outage', 'Traffic signals not working', 7, 6, 'traffic', 1),
('Water Contamination', 'Contaminated water supply', 9, 24, 'water', 1),
('Road Marker Damage', 'Damaged road signs or markers', 3, 2, 'marker', 1),
('Illegal Dumping', 'Illegally dumped waste or rubble', 4, 3, 'dump', 1);
GO

-- 2. EssentialServices
INSERT INTO EssentialServices (name, service_type, address_line, latitude, longitude, ward_number, contact_number)
VALUES 
('Pearson High School',            'School',   'La Roche Drive, Humewood',        -33.97400, 25.65200, 'Ward 3', '+27-41-583-1000'),
('Grey High School',               'School',   'Park Drive, Central',             -33.95560, 25.59310, 'Ward 5', '+27-41-585-2000'),
('Alexander Road High School',     'School',   'Rochelle Street, Walmer',         -33.99320, 25.60960, 'Ward 7', '+27-41-581-3000'),
('Charter House School',           'School',   '2nd Avenue, Summerstrand',        -33.98720, 25.66850, 'Ward 3', '+27-41-583-4000'),
('Framesby High School',           'School',   'Kragga Kamma Road, Greenacres',   -33.95400, 25.58500, 'Ward 9', '+27-41-360-5000'),
('Livingstone Hospital',           'Hospital', 'Stanford Road, Central',          -33.94350, 25.59750, 'Ward 5', '+27-41-405-6000'),
('Life St George''s Hospital',     'Hospital', 'Rochester Road, Central',         -33.94940, 25.58670, 'Ward 5', '+27-41-392-7000'),
('Greenacres Clinic',              'Clinic',   'Ring Road, Greenacres',           -33.95050, 25.58950, 'Ward 9', '+27-41-360-8000'),
('Walmer Community Health Centre', 'Clinic',   'Main Road, Walmer',               -33.99600, 25.60760, 'Ward 7', '+27-41-581-9000'),
('Humewood Medical Centre',        'Clinic',   'Beach Road, Humewood',            -33.97250, 25.64800, 'Ward 3', '+27-41-583-1001');
GO

-- 3. ServiceAreas
INSERT INTO ServiceAreas (area_name, ward_number, description, latitude, longitude, is_active)
VALUES 
('Summerstrand', 'Ward 3',  'Coastal suburb, beachfront and hotel district',       -33.98550, 25.67100, 1),
('Humewood',     'Ward 3',  'Beachfront suburb near the Boardwalk precinct',       -33.97350, 25.64950, 1),
('Central',      'Ward 5',  'City centre, government and commercial hub',          -33.95950, 25.60300, 1),
('Walmer',       'Ward 7',  'Residential suburb south of the city centre',         -33.99500, 25.60800, 1),
('Greenacres',   'Ward 9',  'Residential and retail suburb near Cape Road',        -33.95150, 25.59050, 1);
GO

-- ============================================
-- SEED TEST USERS
-- ============================================

INSERT INTO Users (email, password_hash, firebase_uid, role, is_active, created_at, last_login)
VALUES 
('admin@fixitcity.com', 'hashed_admin_pass', 'firebase_admin_uid_001', 'Municipal', 1, GETDATE(), GETDATE()),
('s229237754@mandela.ac.za', 'hashed_pass_1', 'firebase_citizen_uid_001', 'Citizen', 1, GETDATE(), GETDATE()),
('s229818994@mandela.ac.za', 'hashed_pass_2', 'firebase_citizen_uid_002', 'Citizen', 1, GETDATE(), GETDATE()),
('s229785689@mandela.ac.za', 'hashed_pass_3', 'firebase_citizen_uid_003', 'Citizen', 1, GETDATE(), GETDATE());
GO

-- ============================================
-- SEED MUNICIPAL USERS
-- ============================================

INSERT INTO MunicipalUsers (user_id, employee_id, department, position_title, hire_date, is_active)
VALUES (1, 'EMP-ADMIN-001', 'Port Elizabeth Municipal Services', 'System Administrator', '2024-01-15', 1);
GO

-- ============================================
-- SEED CITIZEN PROFILES
-- ============================================

INSERT INTO CitizenProfiles (user_id, first_name, last_name, phone_number, address_line, city, latitude, longitude, notification_preference)
VALUES 
(2, 'Motheo', 'Kekana', '+27-82-123-4567', '123 Main Rd', 'Central', -33.9608, 25.6022, 'Push'),
(3, 'Malik', 'Ndayisaba', '+27-82-234-5678', '456 7th Ave', 'Walmer', -33.9817, 25.5840, 'Email'),
(4, 'Cohen', 'Geswint', '+27-82-345-6789', '789 Cape Rd', 'Newton Park', -33.9644, 25.5627, 'Push');
GO

-- ============================================
-- SEED FAULT REPORTS (With HARDCODED reference numbers)
-- ============================================

-- Report 1: Burst pipe in Central (Pending)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at,
    is_offline, sync_status
)
VALUES (
    1, 1, 3, 
    'Burst Pipe on Main Road', 
    'Water pipe burst on Main Road near the Post Office. Water flooding the street.', 
    -33.9610, 25.6030, '123 Main Rd, Central',
    'Pending', 
    'FIX-20250901-0001', GETDATE(),
    0, 'Synced'
);

-- Report 2: Pothole in Walmer (Verified)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at, verified_by, verified_at,
    is_offline, sync_status
)
VALUES (
    2, 2, 4, 
    'Large Pothole on 8th Avenue', 
    'Large pothole on 8th Avenue near the Walmer Police Station. Dangerous for vehicles.', 
    -33.9825, 25.5915, '456 8th Ave, Walmer',
    'Verified', 
    'FIX-20250901-0002', DATEADD(HOUR, -2, GETDATE()),
    1, DATEADD(HOUR, -2, GETDATE()),
    0, 'Synced'
);

-- Report 3: Electrical outage in Newton Park (InProgress)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at, assigned_to,
    is_offline, sync_status
)
VALUES (
    3, 4, 5, 
    'Power Outage on Cape Road', 
    'No electricity on Cape Road near Greenacres. Outage for the past 4 hours.', 
    -33.9650, 25.5750, '789 Cape Rd, Newton Park',
    'InProgress', 
    'FIX-20250901-0003', DATEADD(HOUR, -5, GETDATE()),
    1,
    0, 'Synced'
);

-- Report 4: Sewage leak in Humewood (Pending)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at,
    is_offline, sync_status, offline_id
)
VALUES (
    1, 5, 2, 
    'Sewage Leak on Beach Road', 
    'Sewage overflowing from manhole on Beach Road near the Boardwalk.', 
    -33.9730, 25.6500, '123 Beach Rd, Humewood',
    'Pending', 
    'FIX-20250901-0004', DATEADD(HOUR, -1, GETDATE()),
    1, 'Pending', 'OFFLINE-001'
);

-- Report 5: Fallen tree in Summerstrand (Verified)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at, verified_by, verified_at,
    is_offline, sync_status
)
VALUES (
    2, 7, 1, 
    'Fallen Tree on Marine Drive', 
    'Large tree fallen across Marine Drive near Summerstrand. Blocking traffic.', 
    -33.9880, 25.6740, 'Marine Drive, Summerstrand',
    'Verified', 
    'FIX-20250901-0005', DATEADD(HOUR, -8, GETDATE()),
    1, DATEADD(HOUR, -7, GETDATE()),
    0, 'Synced'
);

-- Report 6: Traffic light outage (Pending)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at,
    is_offline, sync_status, offline_id
)
VALUES (
    3, 8, 3, 
    'Traffic Light Not Working on Govan Mbeki', 
    'Traffic lights at Govan Mbeki and Russel Road intersection are dead.', 
    -33.9630, 25.6180, 'Govan Mbeki Ave, Central',
    'Pending', 
    'FIX-20250901-0006', DATEADD(HOUR, -3, GETDATE()),
    1, 'Pending', 'OFFLINE-002'
);

-- Report 7: Streetlight outage (Verified)
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at, verified_by, verified_at,
    is_offline, sync_status
)
VALUES (
    1, 3, 4, 
    'Streetlights Out on Main Road', 
    'Streetlights on Main Road between 6th and 10th Avenue are not working.', 
    -33.9820, 25.5900, 'Main Road, Walmer',
    'Verified', 
    'FIX-20250901-0007', DATEADD(HOUR, -12, GETDATE()),
    1, DATEADD(HOUR, -11, GETDATE()),
    0, 'Synced'
);

-- Report 8: Resolved report
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at, resolved_at, verified_by, assigned_to,
    is_offline, sync_status
)
VALUES (
    2, 6, 5, 
    'Pavement Crack on Cape Road', 
    'Large crack in pavement on Cape Road. Trip hazard.', 
    -33.9660, 25.5730, 'Cape Road, Greenacres',
    'Resolved', 
    'FIX-20250901-0008', DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, -1, GETDATE()),
    1, 1,
    0, 'Synced'
);

-- Report 9: Rejected report
INSERT INTO FaultReports (
    citizen_id, category_id, area_id, title, description, 
    latitude, longitude, address_line, status, 
    reference_number, created_at, verified_by, verified_at,
    is_offline, sync_status
)
VALUES (
    3, 10, 3, 
    'Road Marker Damaged', 
    'Road sign damaged on Beach Road near the Boardwalk.', 
    -33.9790, 25.6380, 'Beach Road, Humewood',
    'Rejected', 
    'FIX-20250901-0009', DATEADD(DAY, -2, GETDATE()),
    1, DATEADD(DAY, -2, GETDATE()),
    0, 'Synced'
);
GO

-- ============================================
-- SEED REPORT PHOTOS
-- ============================================

INSERT INTO ReportPhotos (report_id, photo_url, firebase_storage_path, is_primary, is_offline, sync_status, uploaded_at)
VALUES 
(1, 'https://firebasestorage.googleapis.com/v0/b/fixitcity.appspot.com/o/reports%2F1%2Fphoto1.jpg', 'reports/1/photo1.jpg', 1, 0, 'Synced', GETDATE()),
(1, 'https://firebasestorage.googleapis.com/v0/b/fixitcity.appspot.com/o/reports%2F1%2Fphoto2.jpg', 'reports/1/photo2.jpg', 0, 0, 'Synced', GETDATE()),
(2, 'https://firebasestorage.googleapis.com/v0/b/fixitcity.appspot.com/o/reports%2F2%2Fphoto1.jpg', 'reports/2/photo1.jpg', 1, 0, 'Synced', GETDATE()),
(3, 'https://firebasestorage.googleapis.com/v0/b/fixitcity.appspot.com/o/reports%2F3%2Fphoto1.jpg', 'reports/3/photo1.jpg', 1, 0, 'Synced', GETDATE()),
(4, 'https://firebasestorage.googleapis.com/v0/b/fixitcity.appspot.com/o/reports%2F4%2Fphoto1.jpg', 'reports/4/photo1.jpg', 1, 1, 'Pending', GETDATE());
GO

-- ============================================
-- SEED PRIORITY SCORES
-- ============================================

INSERT INTO PriorityScores (report_id, total_score, severity_factor, proximity_factor, duplicate_factor, age_factor, computed_at)
VALUES 
(1, 80.0, 25.0, 30.0, 5.0, 20.0, GETDATE()),
(2, 70.0, 20.0, 25.0, 10.0, 15.0, GETDATE()),
(3, 65.0, 22.0, 20.0, 5.0, 18.0, GETDATE()),
(4, 85.0, 23.0, 32.0, 10.0, 20.0, GETDATE()),
(5, 60.0, 18.0, 22.0, 5.0, 15.0, GETDATE()),
(6, 55.0, 15.0, 20.0, 5.0, 15.0, GETDATE()),
(7, 50.0, 10.0, 25.0, 0.0, 15.0, GETDATE()),
(8, 45.0, 5.0, 20.0, 0.0, 20.0, GETDATE()),
(9, 30.0, 5.0, 15.0, 0.0, 10.0, GETDATE());
GO

-- Update priority_score in FaultReports
UPDATE FaultReports SET priority_score = (
    SELECT total_score FROM PriorityScores WHERE PriorityScores.report_id = FaultReports.report_id
);
GO

-- ============================================
-- SEED STATUS HISTORY
-- ============================================

INSERT INTO FaultStatusHistory (report_id, old_status, new_status, changed_by, changed_at, notes)
VALUES 
(2, 'Pending', 'Verified', 1, DATEADD(HOUR, -3, GETDATE()), 'Verified by admin - Walmer area'),
(2, 'Verified', 'InProgress', 1, DATEADD(HOUR, -2, GETDATE()), 'Assigned to road maintenance team'),
(3, 'Pending', 'Verified', 1, DATEADD(HOUR, -4, GETDATE()), 'Verified by admin - Newton Park'),
(3, 'Verified', 'InProgress', 1, DATEADD(HOUR, -3, GETDATE()), 'Assigned to electrical team'),
(5, 'Pending', 'Verified', 1, DATEADD(HOUR, -7, GETDATE()), 'Verified by admin - Summerstrand'),
(7, 'Pending', 'Verified', 1, DATEADD(HOUR, -11, GETDATE()), 'Verified by admin - Walmer'),
(8, 'Pending', 'Verified', 1, DATEADD(DAY, -3, GETDATE()), 'Verified by admin'),
(8, 'Verified', 'InProgress', 1, DATEADD(DAY, -2, GETDATE()), 'Assigned to maintenance team'),
(8, 'InProgress', 'Resolved', 1, DATEADD(DAY, -1, GETDATE()), 'Pavement repaired successfully'),
(9, 'Pending', 'Rejected', 1, DATEADD(DAY, -2, GETDATE()), 'Rejected - Not municipal responsibility');
GO

-- ============================================
-- SEED REPORT FEEDBACK
-- ============================================

INSERT INTO ReportFeedback (report_id, citizen_id, rating, comment, response_time, is_anonymous, created_at)
VALUES 
(2, 2, 4, 'Report was verified quickly. Waiting for repair.', 2, 0, DATEADD(DAY, -1, GETDATE())),
(3, 3, 5, 'Power restored in 6 hours. Excellent service!', 1, 0, DATEADD(DAY, -2, GETDATE())),
(8, 2, 4, 'Pavement repaired within 2 days. Good work.', 3, 0, DATEADD(DAY, -1, GETDATE()));
GO

-- ============================================
-- SEED NOTIFICATIONS
-- ============================================

INSERT INTO Notifications (citizen_id, report_id, notification_type, channel, subject, message, device_token, is_sent, sent_at, is_read, read_at, is_delivered)
VALUES 
(2, 2, 'StatusUpdate', 'Push', 'Pothole Report Verified', 'Your pothole report in Walmer has been verified.', 'fcm_device_token_001', 1, DATEADD(HOUR, -3, GETDATE()), 1, DATEADD(HOUR, -2, GETDATE()), 1),
(2, 2, 'StatusUpdate', 'Push', 'Pothole Report In Progress', 'Your pothole report is now being worked on.', 'fcm_device_token_001', 1, DATEADD(HOUR, -2, GETDATE()), 0, NULL, 1),
(3, 3, 'StatusUpdate', 'Push', 'Power Outage Verified', 'Your power outage report has been verified.', 'fcm_device_token_002', 1, DATEADD(HOUR, -4, GETDATE()), 1, DATEADD(HOUR, -3, GETDATE()), 1),
(3, 3, 'StatusUpdate', 'Push', 'Power Outage In Progress', 'Your power outage report is now in progress.', 'fcm_device_token_002', 1, DATEADD(HOUR, -3, GETDATE()), 0, NULL, 1),
(1, 1, 'StatusUpdate', 'Push', 'Burst Pipe Report Received', 'Your burst pipe report has been received.', 'fcm_device_token_003', 1, DATEADD(HOUR, -2, GETDATE()), 0, NULL, 1),
(1, 4, 'StatusUpdate', 'Push', 'Sewage Leak Report Received', 'Your sewage leak report has been received.', 'fcm_device_token_003', 1, DATEADD(HOUR, -1, GETDATE()), 0, NULL, 0),
(2, 5, 'StatusUpdate', 'Push', 'Fallen Tree Report Verified', 'Your fallen tree report has been verified.', 'fcm_device_token_001', 1, DATEADD(HOUR, -7, GETDATE()), 0, NULL, 1);
GO

-- ============================================
-- SEED DUPLICATE REPORTS
-- ============================================

INSERT INTO DuplicateReports (original_report_id, duplicate_report_id, match_percentage, marked_by, marked_at, is_merged)
VALUES (1, 6, 85.5, 1, GETDATE(), 0);
GO

-- ============================================
-- SEED DEVICE TOKENS
-- ============================================

INSERT INTO DeviceTokens (user_id, device_token, device_type, device_name, is_active, created_at, last_used_at)
VALUES 
(2, 'fcm_device_token_001', 'Android', 'Samsung Galaxy S23', 1, GETDATE(), GETDATE()),
(3, 'fcm_device_token_002', 'Android', 'Google Pixel 7', 1, GETDATE(), GETDATE()),
(4, 'fcm_device_token_003', 'Android', 'Samsung Galaxy A15', 1, GETDATE(), GETDATE());
GO

-- ============================================
-- SEED AUDIT LOGS
-- ============================================

INSERT INTO AuditLogs (municipal_user_id, action, table_affected, record_id, old_values, new_values, ip_address, created_at)
VALUES 
(1, 'Verify Report', 'FaultReports', 2, '{"status":"Pending"}', '{"status":"Verified"}', '192.168.1.1', DATEADD(HOUR, -3, GETDATE())),
(1, 'Update Status', 'FaultReports', 2, '{"status":"Verified"}', '{"status":"InProgress"}', '192.168.1.1', DATEADD(HOUR, -2, GETDATE())),
(1, 'Verify Report', 'FaultReports', 3, '{"status":"Pending"}', '{"status":"Verified"}', '192.168.1.1', DATEADD(HOUR, -4, GETDATE())),
(1, 'Update Status', 'FaultReports', 3, '{"status":"Verified"}', '{"status":"InProgress"}', '192.168.1.1', DATEADD(HOUR, -3, GETDATE())),
(1, 'Verify Report', 'FaultReports', 5, '{"status":"Pending"}', '{"status":"Verified"}', '192.168.1.1', DATEADD(HOUR, -7, GETDATE())),
(1, 'Verify Report', 'FaultReports', 7, '{"status":"Pending"}', '{"status":"Verified"}', '192.168.1.1', DATEADD(HOUR, -11, GETDATE())),
(1, 'Resolve Report', 'FaultReports', 8, '{"status":"InProgress"}', '{"status":"Resolved"}', '192.168.1.1', DATEADD(DAY, -1, GETDATE())),
(1, 'Reject Report', 'FaultReports', 9, '{"status":"Pending"}', '{"status":"Rejected"}', '192.168.1.1', DATEADD(DAY, -2, GETDATE()));