using System;
using System.Collections.Generic;

namespace FixITCityAPI.Models;

public partial class EssentialService
{
    public int ServiceId { get; set; }

    public string? Name { get; set; }

    public string? ServiceType { get; set; }

    public string? AddressLine { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }
}
