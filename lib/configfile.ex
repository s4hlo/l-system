defmodule Configfile do
  @config_file "setup.cfg"

  def save(config) do
    content = [
      "type=#{config.type}",
      "axiom=#{config.axiom}",
      "rules=#{encode_rules(config.rules, config.type)}",
      "iterations=#{config.iterations}",
      "angle=#{config.angle}",
      "length=#{config.length}"
    ]
    |> Enum.join("\n")

    File.write!(@config_file, content)
    IO.puts("\nConfiguration saved to #{@config_file}")
  end

  def read() do
    content = File.read!(@config_file)

    config = content
    |> String.split("\n")
    |> Enum.reduce(%{}, fn line, acc ->
      case String.split(line, "=", parts: 2) do
        [key, value] ->
          Map.put(acc, String.to_atom(key), value)
        _ ->
          acc
      end
    end)

    %{
      type: config.type,
      axiom: config.axiom,
      rules: decode_rules(config.rules, config.type),
      iterations: String.to_integer(config.iterations),
      angle: String.to_integer(config.angle),
      length: String.to_integer(config.length)
    }
  end

  def exists?() do
    File.exists?(@config_file)
  end

  def get_filename() do
    @config_file
  end

  defp encode_rules(rules, "deterministic") do
    rules
    |> Enum.map(fn {k, v} -> "#{k}=#{Enum.join(v)}" end)
    |> Enum.join(";")
  end

  defp encode_rules(rules, "stochastic") do
    rules
    |> Enum.flat_map(fn {k, values} ->
      Enum.map(values, fn {v, w} -> "#{k}=#{Enum.join(v)},#{w}" end)
    end)
    |> Enum.join(";")
  end

  defp decode_rules(rules_str, "deterministic") do
    rules_str
    |> String.split(";")
    |> Enum.map(fn rule ->
      [k, v] = String.split(rule, "=", parts: 2)
      {k, String.graphemes(v)}
    end)
    |> Map.new()
  end

  defp decode_rules(rules_str, "stochastic") do
    rules_str
    |> String.split(";")
    |> Enum.map(fn rule ->
      [k, v_w] = String.split(rule, "=", parts: 2)
      [v, w] = String.split(v_w, ",")
      {k, String.graphemes(v), String.to_float(w)}
    end)
    |> Enum.group_by(
      fn {k, _v, _w} -> k end,
      fn {_k, v, w} -> {v, w} end
    )
  end

end
