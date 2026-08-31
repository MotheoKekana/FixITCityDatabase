using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class AuditLog
{
    public int LogId { get; set; }

    public int? MunicipalUserId { get; set; }

    public string? Action { get; set; }

    public string? TableAffected { get; set; }

    public int? RecordId { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual MunicipalUser? MunicipalUser { get; set; }
}
