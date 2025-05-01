using Microsoft.EntityFrameworkCore;
using WeatherApp.Models;

namespace WeatherApp.Data;

public class ReadOnlyWeatherDbContext : DbContext
{
    public ReadOnlyWeatherDbContext(DbContextOptions<ReadOnlyWeatherDbContext> options) : base(options) { }

    public DbSet<WeatherForecast> Forecasts => Set<WeatherForecast>();
}
