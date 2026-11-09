using AyuSaarthi.Api.Middleware;
using AyuSaarthi.Application;
using AyuSaarthi.Infrastructure;
using AyuSaarthi.Infrastructure.Persistence;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplication();
builder.Services.AddInfrastructure(builder.Configuration);

builder.Services.AddControllers();
builder.Services.AddOpenApi();
builder.Services.AddProblemDetails();
builder.Services.AddExceptionHandler<GlobalExceptionHandler>();
builder.Services.AddHealthChecks().AddDbContextCheck<AppDbContext>("database", tags: ["ready"]);

var app = builder.Build();

app.UseExceptionHandler();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.UseAuthorization();

app.MapControllers();
app.MapHealthChecks("/api/health", new() { Predicate = _ => false });
app.MapHealthChecks("/api/health/ready", new() { Predicate = c => c.Tags.Contains("ready") });

app.Run();
