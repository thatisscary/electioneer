namespace Electioneer.Common.Security.Crypto;

    using Azure.Identity;
    using Azure.Security.KeyVault.Keys;
    using NSec.Cryptography;

    

    public class AzureKeyVaultProvider : IKeyProvider
    {
        private readonly string _keyName;
        private readonly KeyClient _client;

        public AzureKeyVaultProvider(string vaultUri, string keyName)
        {
            _keyName = keyName;
            _client = new KeyClient(new Uri(vaultUri), new DefaultAzureCredential());
        }

        public async Task<Key> GetSigningKeyAsync(CancellationToken ct = default)
        {
            var keyResponse = await _client.GetKeyAsync(_keyName, cancellationToken: ct);
            var key = keyResponse.Value;

            // Convert Azure JSON Web Key → NSec Key
            return Key.Import(
                SignatureAlgorithm.Ed25519,
                key.Key.ToOctetKey(), // Azure returns octet form for Ed25519
                KeyBlobFormat.RawPrivateKey);
        }
    }

