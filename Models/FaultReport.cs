using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class FaultReport
{
    public int ReportId { get; set; }

    public int? CitizenId { get; set; }

    public int? CategoryId { get; set; }

    public int? AreaId { get; set; }

    public string? Title { get; set; }

    public string? Description { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    public string? Status { get; set; }

    public int? AssignedTo { get; set; }

    public DateTime? CreatedAt { get; set; }

    public DateTime? ResolvedAt { get; set; }

    public virtual ServiceArea? Area { get; set; }

    public virtual MunicipalUser? AssignedToNavigation { get; set; }

    public virtual FaultCategory? Category { get; set; }

    public virtual CitizenProfile? Citizen { get; set; }

    public virtual ICollection<DuplicateReport> DuplicateReportDuplicateReportNavigations { get; set; } = new List<DuplicateReport>();

    public virtual ICollection<DuplicateReport> DuplicateReportOriginalReports { get; set; } = new List<DuplicateReport>();

    public virtual ICollection<FaultStatusHistory> FaultStatusHistories { get; set; } = new List<FaultStatusHistory>();

    public virtual ICollection<Notification> Notifications { get; set; } = new List<Notification>();

    public virtual ICollection<PriorityScore> PriorityScores { get; set; } = new List<PriorityScore>();

    public virtual ICollection<ReportFeedback> ReportFeedbacks { get; set; } = new List<ReportFeedback>();

    public virtual ICollection<ReportPhoto> ReportPhotos { get; set; } = new List<ReportPhoto>();
}
