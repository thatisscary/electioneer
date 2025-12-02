using Electioneer.Common.Flagging;
using OpenFeature.Model;

namespace Electioneer.Common.Flagging.Tests;

public class FlaggingTests
{
    [Test]
    public async Task Online_Voting_Disabled_By_Default()
    {
        await using var test = await TestContext.Current();
        var service = test.ServiceProvider.GetRequiredService<FeatureFlagService>();

        var enabled = await service.IsOnlineVotingEnabledAsync("99"); // invalid FIPS

        Assert.That(enabled, Is.False);
    }

    [Test]
    public async Task California_Pilot_Enabled_Via_Targeting()
    {
        await using var test = await TestContext.Create();
        var service = test.ServiceProvider.GetRequiredService<FeatureFlagService>();

        var enabled = await service.IsOnlineVotingEnabledAsync("06");

        Assert.That(enabled, Is.True);
    }
}