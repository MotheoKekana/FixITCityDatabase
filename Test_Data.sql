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