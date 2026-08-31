using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class FaultCategory
{
    public int CategoryId { get; set; }

    public string? Name { get; set; }

    public string? Description { get; set; }

    public decimal? SeverityWeight { get; set; }

    public virtual ICollection<FaultReport> FaultReports { get; set; } = new List<FaultReport>();
}
