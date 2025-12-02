using Microsoft.Extensions.DependencyInjection;
using OpenFeature;
using OpenFeature.Contrib.Providers.GOFeatureFlag;

namespace Electioneer.Common.Flagging;

/// <summary>
/// Initializes the OpenFeature provider for GoFeatureFlag Relay Proxy.
/// This decouples flag evaluation from app code, enabling dynamic updates.
/// </summary>
public static class RelayProxyProvider
{
    /// <summary>
    /// Registers the GoFeatureFlag provider with OpenFeature in the DI container.
    /// </summary>
    /// <param name="services">The service collection to extend.</param>
    /// <param name="proxyEndpoint">The HTTP endpoint of the relay proxy (e.g., "http://relay-proxy:1031").</param>
    /// <param name="evaluationTimeoutMs">Timeout for flag evaluations (default: 1000ms).</param>
    public static async Task<IServiceCollection> AddRelayProxyProvider(
        this IServiceCollection services,
        string proxyEndpoint,
        int evaluationTimeoutMs = 1000)
    {
        // Create the GoFeatureFlag provider options
        var providerOptions = new GoFeatureFlagProviderOptions
        {
            Endpoint = proxyEndpoint,
            Timeout = TimeSpan.FromMilliseconds(evaluationTimeoutMs)
        };

        // Initialize the provider
        var provider = new GoFeatureFlagProvider(providerOptions);

        // Set as the default OpenFeature provider
        await Api.Instance.SetProviderAsync(provider);
        

        // Register IFeatureFlagClient for DI (singleton for perf)
        services.AddSingleton<IFeatureClient>(OpenFeature.Api.Instance.GetClient());

        return services;
    }
}