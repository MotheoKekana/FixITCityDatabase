-- ============================================
-- STORED PROCEDURE: Calculate Priority Score
-- ============================================
IF OBJECT_ID('sp_CalculatePriorityScore', 'P') IS NOT NULL
    DROP PROCEDURE sp_CalculatePriorityScore;
GO

CREATE PROCEDURE sp_CalculatePriorityScore
    @ReportID INT
AS
BEGIN
    DECLARE @Severity DECIMAL(6,2);
    DECLARE @Proximity DECIMAL(6,2);
    DECLARE @Duplicate DECIMAL(6,2);
    DECLARE @Age DECIMAL(6,2);
    DECLARE @Total DECIMAL(6,2);

    -- Get severity score (0-25)
    SELECT @Severity = (severity_weight * 2.5)
    FROM FaultReports fr
    JOIN FaultCategories fc ON fr.category_id = fc.category_id
    WHERE fr.report_id = @ReportID;

    -- Get proximity score (0-35) - simplified
    SET @Proximity = 20.0; -- Placeholder, actual calculation would use Haversine formula

    -- Get duplicate score (0-20)
    SELECT @Duplicate = CASE 
        WHEN COUNT(*) > 0 THEN 20.0
        ELSE 0.0
    END
    FROM DuplicateReports
    WHERE original_report_id = @ReportID OR duplicate_report_id = @ReportID;

    -- Get age score (0-20)
    DECLARE @HoursOld INT;
    SELECT @HoursOld = DATEDIFF(HOUR, created_at, GETDATE())
    FROM FaultReports
    WHERE report_id = @ReportID;
    
    SET @Age = CASE 
        WHEN @HoursOld >= 48 THEN 20.0
        WHEN @HoursOld >= 24 THEN 15.0
        WHEN @HoursOld >= 12 THEN 10.0
        WHEN @HoursOld >= 6 THEN 5.0
        ELSE 0.0
    END;

    -- Calculate total
    SET @Total = @Severity + @Proximity + @Duplicate + @Age;

    -- Insert or update PriorityScores
    IF EXISTS (SELECT 1 FROM PriorityScores WHERE report_id = @ReportID)
    BEGIN
        UPDATE PriorityScores SET
            severity_factor = @Severity,
            proximity_factor = @Proximity,
            duplicate_factor = @Duplicate,
            age_factor = @Age,
            total_score = @Total,
            computed_at = GETDATE()
        WHERE report_id = @ReportID;
    END
    ELSE
    BEGIN
        INSERT INTO PriorityScores (report_id, total_score, severity_factor, proximity_factor, duplicate_factor, age_factor)
        VALUES (@ReportID, @Total, @Severity, @Proximity, @Duplicate, @Age);
    END

    -- Update priority_score in FaultReports
    UPDATE FaultReports SET priority_score = @Total WHERE report_id = @ReportID;
END;
