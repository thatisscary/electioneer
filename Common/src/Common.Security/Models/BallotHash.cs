
namespace Electioneer.Common.Security.Models;

/// <summary>
/// Represents a hash value that uniquely identifies a ballot.
/// </summary>
/// <param name="Value">The hash value that uniquely identifies the ballot. Cannot be null or empty.</param>
public record BallotHash(string Value)
{
    public override string ToString() => Value;
}

