namespace WeatherApp.Models;

public class WeatherForecast
{
    public int Id { get; set; }
    public string? Summary { get; set; }
    public int TemperatureC { get; set; }
    public DateTime Date { get; set; }
}
