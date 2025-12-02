namespace Electioneer.Common.Flagging
{
    using System;
    using System.Collections.Generic;
    using System.Text;

    public interface IFeatureFlagClient
    {

    }

    public class GoFeatureFlagClient : IFeatureFlagClient
    {
        public GoFeatureFlagClient() { }
    }
}
