using System.Security.Cryptography;
using System.Text;
using Electioneer.Common.Security.Models;

namespace Electioneer.Common.Security.Hashing;

public class BallotHasher : IBallotHashingService
{
    public BallotHash HashBallot(string canonicalJson)
    {
        var hash = SHA3_512.HashData(Encoding.UTF8.GetBytes(canonicalJson));
        return new BallotHash(Convert.ToBase64String(hash));
    }
}