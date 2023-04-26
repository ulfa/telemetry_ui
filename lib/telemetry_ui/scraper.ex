defmodule TelemetryUI.Scraper do
  @moduledoc false

  import TelemetryUI.Event

  defmodule Options do
    @moduledoc false

    defstruct from: nil, to: nil, event_name: nil, compare: true

    @type t :: %__MODULE__{compare: true}
  end

  def metric(backend, metric, params) do
    filters = struct(Options, params)

    filters = %{
      filters
      | event_name: cast_event_name(metric)
    }

    backend
    |> TelemetryUI.Backend.metric_data(metric, filters)
    |> Enum.map(&map_tags/1)
  end

  defp map_tags(entry) when map_size(entry.tags) === 0 or is_nil(entry.tags) do
    %{entry | tags: nil}
  end

  defp map_tags(entry) do
    update_in(entry, [:tags], fn tags ->
      if map_size(tags) === 1 do
        Enum.map_join(tags, ",", fn {_key, value} -> "#{value}" end)
      else
        Enum.map_join(tags, ",", fn {key, value} -> "#{key}: #{value}" end)
      end
    end)
  end
end
