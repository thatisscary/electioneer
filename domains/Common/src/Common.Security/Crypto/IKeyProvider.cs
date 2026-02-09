namespace Electioneer.Common.Security.Crypto
{
    using NSec.Cryptography;


    /// <summary>
    /// Defines a contract for asynchronously retrieving a cryptographic signing key.
    /// </summary>
    public interface IKeyProvider
    {
        Task<Key> GetSigningKeyAsync(CancellationToken ct = default);
    }
}
