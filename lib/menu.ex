defmodule Menu do
  @config_file "setup.cfg"

  def show_menu() do
    IO.puts("\n=== L-System Generator ===")
    IO.puts("1 - Create new L-System")
    IO.puts("2 - Use saved L-System")
    IO.puts("3 - Show alphabet and examples")
    IO.puts("4 - Exit")
    IO.write("\nChoose an option: ")

    case IO.gets("") |> String.trim() do
      "1" -> create_new_system()
      "2" -> load_saved_system()
      "3" ->
        show_alphabet_info()
        show_menu()
      "4" -> IO.puts("Goodbye!")
      _ ->
        IO.puts("Invalid option")
        show_menu()
    end
  end

  defp show_alphabet_info() do
    IO.puts("\n--- Alphabet ---")
    IO.puts("F - drawing forward")
    IO.puts("f - move forward (no drawing)")
    IO.puts("L - draw a leaf")
    IO.puts("[ - push state (save position)")
    IO.puts("] - pop state (restore position)")
    IO.puts("* - change color")
    IO.puts("+ - turn right")
    IO.puts("- - turn left")
    IO.puts("X - does nothing (used in axiom)")

    IO.puts("\n--- Examples ---")
    IO.puts("Simple tree:")
    IO.puts("  Axiom: X")
    IO.puts("  Rules: X=F+[[X]-X]-F[-FX]+X")
    IO.puts("         F=FF")
    IO.puts("\nKoch curve:")
    IO.puts("  Axiom: F")
    IO.puts("  Rules: F=F+F-F-F+F")
    IO.puts("\nStochastic (with weights):")
    IO.puts("  Axiom: X")
    IO.puts("  Rules: X=F-[[X]+X]+F[+FX]-X,0.6")
    IO.puts("         X=F+[[X]-X]-F[-FX]+X,0.4")
    IO.puts("         F=FF,1.0")
  end

  defp create_new_system() do
    IO.puts("\n=== Creating New L-System ===")

    show_alphabet_info()

    # Choose type
    IO.puts("\nType:")
    IO.puts("1 - Deterministic")
    IO.puts("2 - Stochastic")
    IO.write("Choose: ")
    type = case IO.gets("") |> String.trim() do
      "1" -> "deterministic"
      "2" -> "stochastic"
      _ -> "deterministic"
    end

    # Axiom
    IO.write("\nAxiom: ")
    axiom = IO.gets("") |> String.trim()

    # Rules
    IO.puts("\nRules:")
    show_rule_format(type)
    rules = collect_rules(type, [])

    # Iterations
    IO.write("\nIterations: ")
    iterations = IO.gets("") |> String.trim() |> String.to_integer()

    # Angle
    IO.write("\nAngle (degrees): ")
    angle = IO.gets("") |> String.trim() |> String.to_integer()

    # Length
    IO.write("\nLength (pixels): ")
    length = IO.gets("") |> String.trim() |> String.to_integer()

    rules_map = case type do
      "deterministic" ->
        rules
        |> Enum.map(fn {k, v} -> {k, String.graphemes(v)} end)
        |> Map.new()
      "stochastic" ->
        rules
        |> Enum.map(fn {k, values} ->
          {k, Enum.map(values, fn {v, w} -> {String.graphemes(v), w} end)}
        end)
        |> Map.new()
    end

    config = %{
      type: type,
      axiom: axiom,
      rules: rules_map,
      iterations: iterations,
      angle: angle,
      length: length
    }

    save_config(config)
    execute_system(config)

    show_menu()
  end

  defp show_rule_format("deterministic") do
    IO.puts("Format: A=B (type 'done' when finished)")
    IO.puts("Example: X=F+[[X]-X]-F[-FX]+X")
  end

  defp show_rule_format("stochastic") do
    IO.puts("Format: A=B,weight (type 'done' when finished)")
    IO.puts("Example: X=F-[[X]+X]+F[+FX]-X,0.6")
    IO.puts("You can add multiple rules for the same symbol with different weights")
  end

  defp collect_rules("deterministic", acc) do
    IO.write("Rule: ")
    input = IO.gets("") |> String.trim()

    if input == "done" do
      Enum.reverse(acc)
    else
      case String.split(input, "=") do
        [key, value] -> collect_rules("deterministic", [{String.trim(key), String.trim(value)} | acc])
        _ ->
          IO.puts("Invalid format, use: A=B")
          collect_rules("deterministic", acc)
      end
    end
  end

  defp collect_rules("stochastic", acc) do
    IO.write("Rule (format: A=B,weight or 'done'): ")
    input = IO.gets("") |> String.trim()

    if input == "done" do
      group_stochastic_rules(Enum.reverse(acc))
    else
      case String.split(input, "=") do
        [key, value_weight] ->
          case String.split(value_weight, ",") do
            [value, weight] ->
              key = String.trim(key)
              value = String.trim(value)
              weight = String.trim(weight) |> String.to_float()
              collect_rules("stochastic", [{key, value, weight} | acc])
            _ ->
              IO.puts("Invalid format, use: A=B,0.5")
              collect_rules("stochastic", acc)
          end
        _ ->
          IO.puts("Invalid format, use: A=B,0.5")
          collect_rules("stochastic", acc)
      end
    end
  end

  defp group_stochastic_rules(rules) do
    rules
    |> Enum.group_by(fn {key, _value, _weight} -> key end, fn {_key, value, weight} -> {value, weight} end)
    |> Map.new()
  end

  defp save_config(config) do
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

  defp load_saved_system() do
    if File.exists?(@config_file) do
      IO.puts("\nLoading configuration from #{@config_file}...")
      config = read_config()
      execute_system(config)
      show_menu()
    else
      IO.puts("\nNo saved configuration found (#{@config_file})")
      show_menu()
    end
  end

  defp read_config() do
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

  defp execute_system(config) do
    IO.puts("\nGenerating fractal...")

    axiom = String.graphemes(config.axiom)

    result = case config.type do
      "deterministic" ->
        Sys.l_system_iter(axiom, config.rules, config.iterations)
      "stochastic" ->
        Sys.l_system_iter_stochastic(axiom, config.rules, config.iterations)
    end
    |> Enum.join("")

    Py.generate_and_run_fractal(result, config.length, config.angle)
    IO.puts("Fractal generated!")
  end
end
