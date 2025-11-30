

namespace Electioneer.Common.Serialization;

using System.Text.Json;
using System.Text.Json.Serialization;

public static class CanonicalJsonSerializer
{
    private static readonly JsonSerializerOptions _options = new()
    {
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        Converters = { new SortedDictionaryConverter() }
    };

    public static string Serialize<T>(T obj)
    {
        return JsonSerializer.Serialize(obj, _options);
    }

    public static T? Deserialize<T>(string json)
    {
        return JsonSerializer.Deserialize<T>(json, _options);
    }
}

// Custom converter ensures dictionary keys are always sorted
internal class SortedDictionaryConverter : JsonConverter<Dictionary<string, object>>
{


    public override Dictionary<string, object>? Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
    {
        throw new NotImplementedException();
    }

    public override void Write(Utf8JsonWriter writer, Dictionary<string, object> value, JsonSerializerOptions options)
    {
        writer.WriteStartObject();
        foreach (var kvp in value.OrderBy(k => k.Key))
        {
            writer.WritePropertyName(kvp.Key);
            JsonSerializer.Serialize(writer, kvp.Value, options);
        }
        writer.WriteEndObject();
    }
}