using RICP.Application;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddProblemDetails();

var app = builder.Build();
app.UseExceptionHandler();

// Only process liveness is exposed until Entra token validation is configured.
// Do not add business endpoints before authentication and authorization are implemented.
app.MapGet("/api/health/live", () => TypedResults.Ok(new ServiceStatus("ok")));
app.Run();

public partial class Program { }
