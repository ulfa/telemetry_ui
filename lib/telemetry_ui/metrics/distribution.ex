defmodule TelemetryUI.Metrics.Distribution do
  @moduledoc false

  use TelemetryUI.Metrics

  defimpl TelemetryUI.Web.Component do
    alias TelemetryUI.Web.Components
    alias TelemetryUI.Web.VegaLite.Spec

    @options %Spec.Options{
      field: "count",
      field_label: "Count",
      aggregate: "sum",
      aggregate_label: "Total"
    }

    def to_image(metric, extension, assigns) do
      spec = Components.Buckets.spec(metric, assigns, @options)
      spec = VegaLite.Export.to_json(spec)
      TelemetryUI.VegaLiteConvert.export(spec, extension)
    end

    def to_html(metric, assigns) do
      metric
      |> Components.Buckets.spec(assigns, @options)
      |> TelemetryUI.Web.VegaLite.draw(metric, assigns)
    end
  end
end
