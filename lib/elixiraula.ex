defmodule Elx do
  @moduledoc """
  Documentation for `Elixiraula`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elixiraula.hello()
      :world

  """
  def hello do
    :world
  end

  def to_array(n, ns) do
    case Enum.count(ns) do
      ^n ->
        {:ok, for(k <- 1..n, x <- ns, into: %{}, do: {k, x})}

      _ ->
        :error
    end
  end

  # exemple -> to_matrix(2, 3, [1, 2, 3, 4, 5, 6]) -> {:ok, %{{0,0} => 1, {0,1} => 2, {0,2} => 3, {1,0} => 4, {1,1} => 5, {1,2} => 6}}
  def to_matrix(n, m, ls) do
    if Enum.count(ls) == n * m do
      result =
        for i <- 0..(n - 1), j <- 0..(m - 1), into: %{} do
          index = i * m + j
          element = Enum.at(ls, index)
          {{i, j}, element}
        end

      {:ok, result}
    else
      :error
    end
  end

  # exemple -> get_rows_columns(%{{0,0} => 1, {0,1} => 2, {0,2} => 3, {1,0} => 3, {1,1} => 4, {1,2} => 5}) -> {2, 3}
  def get_rows_columns(matrix) do
    {indices, _values} = Enum.unzip(matrix)
    max_row = indices |> Enum.map(fn {row, _col} -> row end) |> Enum.max()
    max_col = indices |> Enum.map(fn {_row, col} -> col end) |> Enum.max()
    {max_row + 1, max_col + 1}
  end

  # exemple -> sum_matrix(%{{0,0} => 1, {0,1} => 2, {1,0} => 3, {1,1} => 4}, %{{0,0} => 1, {0,1} => 2, {1,0} => 3, {1,1} => 4}) -> {:ok, %{{0,0} => 2, {0,1} => 4, {1,0} => 6, {1,1} => 8}}
  def sum_matrix(matrix1, matrix2) do
    if Enum.count(matrix1) == Enum.count(matrix2) do
      {n, m} = get_rows_columns(matrix1)
      {n2, m2} = get_rows_columns(matrix2)

      if n == n2 and m == m2 do
        result =
          for i <- 0..(n - 1), j <- 0..(m - 1), into: %{} do
            {{i, j}, matrix1[{i, j}] + matrix2[{i, j}]}
          end

        {:ok, result}
      else
        :error
      end
    else
      :error
    end
  end

  def print_matrix(matrix) do
    {n, m} = get_rows_columns(matrix)

    for i <- 0..(n - 1), j <- 0..(m - 1) do
      IO.write("#{matrix[{i, j}]} ")

      if j == m - 1 do
        IO.puts("")
      end
    end
  end

  def print(l) do
    IO.inspect("---------------------")
    IO.inspect(l)
    IO.inspect("---------------------")
  end

  def get_submatrix(matrix) do
    {n, m} = get_rows_columns(matrix)

    print_matrix(matrix)
    lowest = if n > m, do: m, else: n

    result =
      for i <- 0..(lowest - 1), j <- 0..(lowest - 1), into: %{} do
        {{i, j}, matrix[{i, j}]}
      end

    {:ok, result}
  end

  def occursIn(xs, x) do
    Enum.any?(xs, fn y -> y == x end)
  end

  def allOccurIn(xs, ys) do
    Enum.all?(xs, fn x -> Enum.any?(ys, fn y -> y == x end) end)
  end

  def sameElements(xs, ys) do
    Enum.all?(xs, fn x -> Enum.all?(ys, fn y -> y == x end) end)
  end

  def numOccurrences(xs, x) do
    Enum.count(xs, fn y -> y == x end)
  end

  @spec map_bag(list(any())) :: %{optional(any()) => integer()}
  def map_bag(xs) do
    for x <- xs, into: %{}, do: {x, numOccurrences(xs, x)}
  end

  # this retorne a list of tuples
  @spec to_bag(list(any())) :: list({any(), integer()})
  def to_bag(xs) do
    xs
    |> Enum.uniq()
    |> Enum.map(fn x -> {x, numOccurrences(xs, x)} end)
  end

  def crossOut(ns, n) do
    for x <- ns, rem(x, n) != 0 or x == n do
      x
    end
  end

  def to_list_evens(f) do
    Enum.to_list(f)
    |> Enum.filter(fn x -> rem(x, 2) == 0 end)
  end

  def sieve([]), do: []

  def sieve([head | tail]) do
    [head | sieve(crossOut(tail, head))]
  end

  def pairs(xs, ys) do
    for x <- xs, y <- ys do
      {x, y}
    end
  end

  # return true or false
  @spec goldbach(List) :: boolean()
  def goldbach(ns) do
    ns_length = Enum.count(ns)
    primes = sieve(Enum.to_list(2..ns_length))
    prime_pairs = pairs(primes, primes)

    evens = Enum.filter(ns, fn x -> rem(x, 2) == 0 and x > 2 end)

    Enum.all?(evens, fn even_num ->
      Enum.any?(prime_pairs, fn {p1, p2} -> p1 + p2 == even_num end)
    end)
  end

  # return true or false
  def triades(ns) do
    power_list = Enum.map(ns, fn x -> x * x end)

    filtered_power_list = Enum.filter(power_list, fn x -> x in ns end)

    pairs = pairs(filtered_power_list, filtered_power_list)

    pair_sums = Enum.map(pairs, fn {x, y} -> {x, y, x + y} end)

    Enum.filter(pair_sums, fn {_x, _y, z} -> z in power_list end)
  end

  def perfect_number(n) do
    divisors = Enum.filter(1..n, fn x -> rem(n, x) == 0 and x != n end)
    divsor_sum = Enum.sum(divisors)
    divsor_sum == n
  end

  # ----------------------------- L-System -----------------------------

  # F -> move forward and draw
  # f -> move forward without drawing
  # + -> turn right
  # - -> turn left
  # [ -> push the current state to the stack
  # ] -> pop the state from the stack
  def l_system(axiom, rules) do
    axiom
    |> String.graphemes()
    |> Enum.map(fn x -> Map.get(rules, x, x) end)
    |> Enum.join("")
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

    commands = l_system_string
    |> String.graphemes()
    |> Enum.map(fn char ->
      case char do
        "F" -> "pen.forward(length)\n"
        "f" -> "pen.penup()\npen.forward(length)\npen.pendown()\n"
        "+" -> "pen.right(angle)\n"
        "-" -> "pen.left(angle)\n"
        "[" -> "stack.append((pen.position(), pen.heading()))\n"
        "]" -> "pos, ang = stack.pop()\npen.penup()\npen.setposition(pos)\npen.setheading(ang)\npen.pendown()\n"
        _ -> ""
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

  def generate_and_run_fractal(axiom, rules, iterations, length, angle, filename \\ "fractal.py") do
    # Gerar string L-system
    l_string = l_system_iter(axiom, rules, iterations)

    # Salvar arquivo Python
    save_python_file(filename, l_string, length, angle)

    # Executar o arquivo
    {output, exit_code} = run_python_file(filename)

    {output, exit_code, filename}
  end

  def runner() do
    # "wiki_plant": {
    #     "axiom": "-X",
    #     "rules": %{"X" => "F+[[X]-X]-F[-FX]+X", "F" => "FF"},
    #     "angle": 25,
    # },

    # Gerar e executar fractal automaticamente
    generate_and_run_fractal("-X", %{"X" => "F+[[X]-X]-F[-FX]+X", "F" => "FF"}, 5, 10, 25)
  end
end
