namespace RICP.Application;

// Process liveness only: this response makes no claim about DB or authentication readiness.
public sealed record ServiceStatus(string Status);
