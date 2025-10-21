defmodule Py do
  def generate_codestring(l_system_string, length, angle) do
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

  def save_file(filename, l_system_string, length, angle) do
    python_code = generate_codestring(l_system_string, length, angle)
    File.write!(filename, python_code)
    {:ok, filename}
  end

  def run_file(filename) do
    System.cmd("python3", [filename])
  end

  def generate_and_run_fractal(l_string, length, angle, filename \\ "fractal.py") do
    save_file(filename, l_string, length, angle)

    {output, exit_code} = run_file(filename)

    {output, exit_code, filename}
  end
end
