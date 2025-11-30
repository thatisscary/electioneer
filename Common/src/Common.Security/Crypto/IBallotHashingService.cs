namespace Electioneer.Common.Security.Hashing
{
    using Electioneer.Common.Security.Models;

    public interface IBallotHashingService
    {
        BallotHash HashBallot(string canonicalJson);
    }
}