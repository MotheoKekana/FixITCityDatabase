-- ============================================
-- FIXITCITY SEED DATA - FIREBASE READY
-- ============================================

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