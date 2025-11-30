namespace Electioneer.Common.Audit;

using System.Security.Cryptography;
using System.Text;

public record AuditEvent(
    Guid EventId,
    DateTimeOffset Timestamp,
    string ActorId,           // e.g., "voter:abc123" or "admin:jane"
    string Action,            // "Ballot.Cast", "Provisional.Resolved"
    string EntityType,
    string EntityId,
    Dictionary<string, object> Payload,
    string PreviousEventHash) // chain integrity
{
    public string CurrentHash => ComputeHash(this);

    public static string ComputeHash(AuditEvent e) =>
        Convert.ToBase64String(
            SHA3_512.HashData(
                Encoding.UTF8.GetBytes($"{e.EventId}{e.Timestamp:o}{e.ActorId}{e.Action}{e.EntityId}{e.PreviousEventHash}")));
}

// src/Common.Audit/IAuditLog.cs
public interface IAuditLog
{
    Task AppendAsync(AuditEvent auditEvent, CancellationToken ct = default);
    IAsyncEnumerable<AuditEvent> StreamFromAsync(string previousHash = "", CancellationToken ct = default);
    Task<bool> VerifyChainAsync(CancellationToken ct = default);
}