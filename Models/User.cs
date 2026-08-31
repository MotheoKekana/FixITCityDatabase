using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class User
{
    public int UserId { get; set; }

    public string? Email { get; set; }

    public string? PasswordHash { get; set; }

    public string? Role { get; set; }

    public DateTime? CreatedAt { get; set; }

    public virtual ICollection<CitizenProfile> CitizenProfiles { get; set; } = new List<CitizenProfile>();

    public virtual ICollection<MunicipalUser> MunicipalUsers { get; set; } = new List<MunicipalUser>();
}
