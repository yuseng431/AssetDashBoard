using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Mvc.Testing;
using RICP.Application;
using Xunit;

namespace RICP.Api.Tests;

public sealed class ApiTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly HttpClient client;

    public ApiTests(WebApplicationFactory<Program> factory)
    {
        client = factory.CreateClient();
    }

    [Fact]
    public async Task LivenessWorksWithoutDatabaseOrEntraConfiguration()
    {
        var response = await client.GetAsync("/api/health/live");
        Assert.Equal(HttpStatusCode.OK, response.StatusCode);
        Assert.Equal("ok", (await response.Content.ReadFromJsonAsync<ServiceStatus>())?.Status);
    }

    [Theory]
    [InlineData("GET", "/api/stores")]
    [InlineData("GET", "/api/assets")]
    [InlineData("POST", "/api/admin/sync-runs")]
    public async Task BusinessRoutesAreUnavailableUntilSecurityIsImplemented(string method, string path)
    {
        using var request = new HttpRequestMessage(new HttpMethod(method), path);
        var response = await client.SendAsync(request);
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }
}
