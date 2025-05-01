using Microsoft.AspNetCore.Mvc;
using WeatherApp.Data;
using WeatherApp.Models;

namespace WeatherApp.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private readonly WeatherDbContext _context;
    private readonly ReadOnlyWeatherDbContext _roContext;

    public WeatherForecastController(WeatherDbContext context, ReadOnlyWeatherDbContext roContext)
    {
        _context = context;
        _roContext = roContext;
    }

    [HttpGet]
    public IEnumerable<WeatherForecast> Get() =>
        _roContext.Forecasts.OrderByDescending(f => f.Date).Take(10);

    [HttpPost]
    public IActionResult Create(WeatherForecast forecast)
    {
        forecast.Date = DateTime.UtcNow;
        _context.Forecasts.Add(forecast);
        _context.SaveChanges();
        return CreatedAtAction(nameof(Get), forecast);
    }
}
