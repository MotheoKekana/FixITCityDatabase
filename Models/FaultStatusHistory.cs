using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class FaultStatusHistory
{
    public int HistoryId { get; set; }

    public int? ReportId { get; set; }

    public string? OldStatus { get; set; }

    public string? NewStatus { get; set; }

    public int? ChangedBy { get; set; }

    public DateTime? ChangedAt { get; set; }

    public string? Notes { get; set; }

    public virtual MunicipalUser? ChangedByNavigation { get; set; }

    public virtual FaultReport? Report { get; set; }
}
