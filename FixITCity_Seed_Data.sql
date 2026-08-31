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