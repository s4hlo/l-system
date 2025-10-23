defmodule Menu do
  def show_menu() do
    IO.puts("\n=== L-System Generator ===")
    IO.puts("1 - Load setup.cfg")
    IO.puts("2 - Load custom file")
    IO.puts("3 - Show alphabet and examples")
    IO.puts("4 - Exit")
    IO.write("\nChoose an option: ")

    case IO.gets("") |> String.trim() do
      "1" -> load_default_config()
      "2" -> load_custom_file()
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

    IO.puts("\n--- Config File Format (setup.cfg) ---")
    IO.puts("type=deterministic")
    IO.puts("axiom=X")
    IO.puts("rules=X=F+[[X]-X]-F[-FX]+X;F=FF")
    IO.puts("iterations=4")
    IO.puts("angle=25")
    IO.puts("length=10")
  end

  defp load_default_config() do
    if File.exists?("setup.cfg") do
      IO.puts("\nLoading setup.cfg...")
      config = Configfile.read("setup.cfg")
      Sys.execute_system(config)
      show_menu()
    else
      IO.puts("\nFile 'setup.cfg' not found")
      show_menu()
    end
  end

  defp load_custom_file() do
    IO.write("\nEnter file path: ")
    filepath = IO.gets("") |> String.trim()

    if File.exists?(filepath) do
      IO.puts("\nLoading #{filepath}...")
      config = Configfile.read(filepath)
      Sys.execute_system(config)
      show_menu()
    else
      IO.puts("\nFile '#{filepath}' not found")
      show_menu()
    end
  end
end
