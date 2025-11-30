using System.Text;
using Electioneer.Common.Security.Models;
using Microsoft.Extensions.Logging;
using NSec.Cryptography;

namespace Electioneer.Common.Security.Crypto;

/// <summary>
/// Provides functionality to sign and verify digital receipts using cryptographic keys.
/// </summary>
/// <remarks>The ReceiptSigner class is typically used in scenarios where the authenticity and integrity of a
/// receipt must be ensured, such as in secure voting or transaction systems. It relies on an injected key provider for
/// cryptographic operations and supports both asynchronous signing and synchronous verification of receipts. This class
/// is thread-safe for concurrent use.</remarks>
public class ReceiptSigner : IReceiptSigner
{
    private readonly IKeyProvider _keyProvider;
    private readonly ILogger<ReceiptSigner> _logger;

    public ReceiptSigner(IKeyProvider keyProvider, ILogger<ReceiptSigner> logger)
    {
        _keyProvider = keyProvider;
        _logger = logger;
    }

    public async Task<SignedReceipt> SignReceiptAsync(
        string ballotId,
        string voterIdHash,
        string receiptJson,
        CancellationToken ct = default)
    {
        var key = await _keyProvider.GetSigningKeyAsync(ct);
        var algorithm = SignatureAlgorithm.Ed25519;

        var data = Encoding.UTF8.GetBytes($"{ballotId}:{voterIdHash}:{receiptJson}");
        var signature = algorithm.Sign(key, data);

        return new SignedReceipt(
            BallotId: ballotId,
            VoterIdHash: voterIdHash,
            CastAt: DateTimeOffset.UtcNow,
            ReceiptDataJson: receiptJson,
            SignatureBase64: Convert.ToBase64String(signature),
            PublicKeyPem: Convert.ToBase64String(key.PublicKey.Export(KeyBlobFormat.PkixPublicKey))
        );
    }


    public bool VerifyReceipt(SignedReceipt receipt)
    {
        try
        {
            var publicKeyBytes = Convert.FromBase64String(receipt.PublicKeyPem);
            var publicKey = PublicKey.Import(SignatureAlgorithm.Ed25519, publicKeyBytes, KeyBlobFormat.PkixPublicKey);
            var data = Encoding.UTF8.GetBytes($"{receipt.BallotId}:{receipt.VoterIdHash}:{receipt.ReceiptDataJson}");
            var signatureBytes = Convert.FromBase64String(receipt.SignatureBase64);

            return SignatureAlgorithm.Ed25519.Verify(publicKey, data, signatureBytes);
        }
        catch
        {
            return false;
        }
    }

}