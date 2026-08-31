using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class ReportPhoto
{
    public int PhotoId { get; set; }

    public int? ReportId { get; set; }

    public string? PhotoUrl { get; set; }

    public DateTime? UploadedAt { get; set; }

    public virtual FaultReport? Report { get; set; }
}
