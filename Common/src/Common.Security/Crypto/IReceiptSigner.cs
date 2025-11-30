

namespace Electioneer.Common.Security.Crypto;

using Electioneer.Common.Security.Models;

/// <summary>
/// Defines methods for digitally signing and verifying election receipts.
/// </summary>
/// <remarks>Implementations of this interface provide functionality to create cryptographically signed
/// receipts and to verify the authenticity of signed receipts. This is typically used in electronic voting systems
/// to ensure the integrity and non-repudiation of voter receipts.</remarks>

public interface IReceiptSigner
    {
        Task<SignedReceipt> SignReceiptAsync(
            string ballotId,
            string voterIdHash,
            string receiptJson,
            CancellationToken ct = default);

        bool VerifyReceipt(SignedReceipt receipt);
    }




