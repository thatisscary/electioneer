using Electioneer.Common.Security.Crypto;
using Electioneer.Common.Security.Models;
using NSec.Cryptography;

namespace Electioneer.Common.Security.Tests;

public class ReceiptSignerTests
{
    [Test]
    public async Task Sign_And_Verify_RoundTrip_Succeeds()
    {
        await using var test = await TestContext.Create();

        var key = Key.Create(SignatureAlgorithm.Ed25519);
        var provider = new InMemoryKeyProvider(key); // simple test double
        var signer = new ReceiptSigner(provider, NullLogger<ReceiptSigner>.Instance);

        var receipt = await signer.SignReceiptAsync(
            ballotId: "B-2025-001",
            voterIdHash: "vhash-abc123",
            receiptJson: """{"contest":"President"}""");

        var verified = signer.VerifyReceipt(receipt);

        Assert.That(verified, Is.True);
    }
}