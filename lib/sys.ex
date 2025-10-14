defmodule Sys do
  # ----------------------------- L-System -----------------------------

  def l_system(axiom, rules) when is_map(rules) do
    axiom
    |> String.graphemes()
    |> Enum.map(fn x -> Map.get(rules, x, x) end)
    |> Enum.join("")
  end

  def l_system_stochastic(axiom, rules) do
    axiom
    |> String.graphemes()
    |> Enum.map(fn x ->
      case Map.get(rules, x) do
        rules_list when is_list(rules_list) ->
          # Calcular probabilidades normalizadas baseadas nos pesos
          total_weight = Enum.sum(Enum.map(rules_list, fn {_rule, weight} -> weight end))

          # Escolher uma regra baseada na probabilidade normalizada
          random_val = :rand.uniform()

          {_, selected_rule} = Enum.reduce_while(rules_list, {0.0, nil}, fn {rule, weight}, {cumulative, _} ->
            normalized_prob = weight / total_weight
            new_cumulative = cumulative + normalized_prob
            if random_val <= new_cumulative do
              {:halt, {new_cumulative, rule}}
            else
              {:cont, {new_cumulative, nil}}
            end
          end)

          selected_rule || x
        _ -> x
      end
    end)
    |> Enum.join("")
  end

  def l_system_iter_stochastic(axiom, rules, n) do
    Enum.reduce(1..n, axiom, fn _i, current ->
      l_system_stochastic(current, rules)
    end)
  end

  def l_system_iter(axiom, rules, n) do
    Enum.reduce(1..n, axiom, fn _i, current ->
      l_system(current, rules)
    end)
  end

  def generate_python_codestring(l_system_string, length, angle) do
    header = """
    import turtle

    length = #{length}
    angle = #{angle}
    pen = turtle.Turtle()
    pen.speed(0)
    turtle.tracer(2, 0)

    turtle.bgcolor("#1e1e2e")
    pen.pencolor("#cba6f7")
    pen.pensize(3)

    pen.penup()
    pen.goto(300, -300)
    pen.pendown()
    pen.left(90)

    # Stack for push/pop operations
    stack = []

    """

    commands =
      l_system_string
      |> String.graphemes()
      |> Enum.map(fn char ->
        case char do
          "F" ->
            "pen.forward(length)\n"

          "f" ->
            "pen.penup()\npen.forward(length)\npen.pendown()\n"

          "+" ->
            "pen.right(angle)\n"

          "-" ->
            "pen.left(angle)\n"

          "[" ->
            "stack.append((pen.position(), pen.heading()))\n"

          "]" ->
            "pos, ang = stack.pop()\npen.penup()\npen.setposition(pos)\npen.setheading(ang)\npen.pendown()\n"

          _ ->
            ""
        end
      end)
      |> Enum.join("")

    header <> commands <> "\nturtle.done()\n"
  end

  def save_python_file(filename, l_system_string, length, angle) do
    python_code = generate_python_codestring(l_system_string, length, angle)
    File.write!(filename, python_code)
    {:ok, filename}
  end

  def run_python_file(filename) do
    System.cmd("python3", [filename])
  end

  def generate_and_run_fractal(l_string, length, angle, filename \\ "fractal.py") do
    # Gerar string L-system

    # Salvar arquivo Python
    save_python_file(filename, l_string, length, angle)

    # Executar o arquivo
    {output, exit_code} = run_python_file(filename)

    {output, exit_code, filename}
  end

  def runner() do
    # Inicializar o gerador de números aleatórios
    :rand.seed(:exs1024, {123, 456, 789})

    axiom = "-X"
    rules_stochastic = %{"X" => [{"F-[[X]+X]+F[+FX]-X", 0.1}, {"F+[[X]-X]-F[-FX]+X", 0.9}], "F" => [{"FF", 1.0}]}
    # rules = %{"X" => "F+[[X]-X]-F[-FX]+X", "F" => "FF"}
    iterations = 5
    # l_string = l_system_iter(axiom, rules, iterations)
    l_string_stochastic = l_system_iter_stochastic(axiom, rules_stochastic, iterations)
    # generate_and_run_fractal(l_string, 10, 25)
    # l_string_stochastic
    generate_and_run_fractal(l_string_stochastic, 10, 25)
  end
end
