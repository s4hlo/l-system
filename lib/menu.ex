defmodule Menu do
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

    Configfile.save(config)
    Sys.execute_system(config)

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

  defp load_saved_system() do
    if Configfile.exists?() do
      IO.puts("\nLoading configuration from #{Configfile.get_filename()}...")
      config = Configfile.read()
      Sys.execute_system(config)
      show_menu()
    else
      IO.puts("\nNo saved configuration found (#{Configfile.get_filename()})")
      show_menu()
    end
  end

end
