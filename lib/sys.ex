defmodule Sys do
  # ----------------------------- L-System -----------------------------

  def l_system(axiom, rules) when is_map(rules) do
    axiom
    |> Enum.flat_map(fn x -> Map.get(rules, x, [x]) end)
  end

  ## TODO entender
  def l_system_stochastic(axiom, rules) do
    axiom
    |> Enum.flat_map(fn x ->
      case Map.get(rules, x) do
        rules_list when is_list(rules_list) ->
          total_weight = Enum.sum(Enum.map(rules_list, fn {_rule, weight} -> weight end))

          random_val = :rand.uniform()

          {_, selected_rule} =
            Enum.reduce_while(rules_list, {0.0, nil}, fn {rule, weight}, {cumulative, _} ->
              normalized_prob = weight / total_weight
              new_cumulative = cumulative + normalized_prob

              if random_val <= new_cumulative do
                {:halt, {new_cumulative, rule}}
              else
                {:cont, {new_cumulative, nil}}
              end
            end)

          selected_rule || [x]

        _ ->
          [x]
      end
    end)
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

    colors = ["#cba6f7", "#5d9b58", "#cba6f7", "#a6e3a1"]
    color_index = 0
    color = colors[color_index]

    def cpz(pensize):
      return pensize - 0

    turtle.bgcolor("#1e1e2e")
    pen.pencolor(color)
    pen.pensize(4)

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
            """
            pen.penup()
            pen.forward(length)
            pen.pendown()
            """

          "L" ->
            """
            pen.pensize(2)
            pen.fillcolor(color)
            pen.begin_fill()
            pen.circle(30, 60)
            pen.left(120)
            pen.circle(30, 60)
            pen.left(120)
            pen.end_fill()
            pen.pensize(2)
            """

          "*" ->
            """
            color_index = (color_index + 1) % 4
            color = colors[color_index]
            pen.pencolor(color)
            """

          "+" ->
            """
            pen.right(angle)
            """

          "-" ->
            """
            pen.left(angle)
            """

          "[" ->
            """
            stack.append((pen.position(), pen.heading(), pen.pensize()))
            pen.pensize(max(1, cpz(pen.pensize())))
            """

          "]" ->
            """
            pos, ang, pensize = stack.pop()
            pen.penup()
            pen.setposition(pos)
            pen.setheading(ang)
            pen.pendown()
            pen.pensize(max(1, cpz(pensize)))
            """

          "X" ->
            ""

          _ ->
            :error
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
    save_python_file(filename, l_string, length, angle)

    {output, exit_code} = run_python_file(filename)

    {output, exit_code, filename}
  end

  def runner() do
    # Inicializar o gerador de números aleatórios
    :rand.seed(:exs1024, {123, 456, 789})

    iterations = 4

    # axiom = "-X" |> String.graphemes()

    # rules_stochastic = %{"X" => [{"F-[[X*L*]+X]+F[+FX*L*]-X*L*", 0.1}, {"F+[[X*L*]-X]-F[-FX*L*]+X*L*", 0.9}], "F" => [{"FF", 1.0}]} |> Map.new(
    #   fn {k, v} -> {k, Enum.map(v, fn {rule, weight} -> {String.graphemes(rule), weight} end)} end
    # )

    # result = l_system_iter_stochastic(axiom, rules_stochastic, iterations) |> Enum.join("")
    # generate_and_run_fractal(result, 10, 25)


    axiom = "-X" |> String.graphemes()
    rules = %{"X" => "F+[[X]-X*L*]-F[-FX]+X*L*", "F" => "FF"} |> Map.new(fn {k, v} -> {k, String.graphemes(v)} end)
    result = l_system_iter(axiom, rules, iterations) |> Enum.join("")



    # special details
    # color of leaves changes every spawn
    generate_and_run_fractal(result, 10, 25)
  end
end
