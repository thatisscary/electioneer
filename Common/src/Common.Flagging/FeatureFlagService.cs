namespace Electioneer.Common.Flagging
{
    using System;
    using System.Collections.Generic;
    using System.Text;
    using OpenFeature;
    using OpenFeature;

    public class FeatureFlagService
    {
        private readonly IFeatureClient _client;

        public FeatureFlagService(IFeatureClient client)
        {
            _client = client;
        }


    }
}
