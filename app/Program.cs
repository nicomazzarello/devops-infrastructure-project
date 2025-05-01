using Microsoft.EntityFrameworkCore;
using WeatherApp.Data;

var builder = WebApplication.CreateBuilder(args);

// Use env var ConnectionStrings__Default for PostgreSQL
var connectionString = builder.Configuration.GetConnectionString("Default");
var roConnectionString = builder.Configuration.GetConnectionString("ReadOnly");
builder.Services.AddDbContext<WeatherDbContext>(options =>
    options.UseNpgsql(connectionString));
builder.Services.AddDbContext<ReadOnlyWeatherDbContext>(options =>
    options.UseNpgsql(roConnectionString));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddHealthChecks();

var app = builder.Build();

app.UseAuthorization();
app.MapControllers();
app.MapHealthChecks("/healthcheck");
app.Run();
