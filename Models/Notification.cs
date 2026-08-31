using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class Notification
{
    public int NotificationId { get; set; }

    public int? CitizenId { get; set; }

    public int? ReportId { get; set; }

    public string? Channel { get; set; }

    public string? Message { get; set; }

    public DateTime? SentAt { get; set; }

    public DateTime? ReadAt { get; set; }

    public virtual CitizenProfile? Citizen { get; set; }

    public virtual FaultReport? Report { get; set; }
}
