using System.Text.RegularExpressions;

namespace Electioneer.Common.Domain;

public readonly record struct StateFips
{
    private static readonly Regex FipsRegex = new(@"^(0[1-9]|[1-5][0-9]|60|66|69|72|74|78)$", RegexOptions.Compiled);

    public string Value { get; }

    public StateFips(string value) 
    {
         if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("FIPS code cannot be empty");
        if (!FipsRegex.IsMatch(value))
            throw new ArgumentException($"Invalid FIPS code: {value}");
    
    }

    public override string ToString() => Value;
    public static implicit operator string(StateFips f) => f.Value;
}

// src/Common.Domain/VoterId.cs
public readonly record struct VoterId
{
    public string Value { get; }
        public VoterId(string value) 
    {
        Value = value;
        if (string.IsNullOrWhiteSpace(value))
            throw new ArgumentException("VoterId cannot be empty");
    }
}