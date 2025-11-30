namespace Electioneer.Common.Security.Models;

/// <summary>
/// A signed receipt for a cast ballot.
/// </summary>
/// <param name="BallotId"></param>
/// <param name="VoterIdHash"></param>
/// <param name="CastAt"></param>
/// <param name="ReceiptDataJson"></param>
/// <param name="SignatureBase64"></param>
/// <param name="PublicKeyPem"></param>
public record SignedReceipt(
    string BallotId,
    string VoterIdHash,           // NEVER raw VoterId
    DateTimeOffset CastAt,
    string ReceiptDataJson,
    string SignatureBase64,
    string PublicKeyPem);
