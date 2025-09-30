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

  def caller() do
    to_bag([1, 2, 3, 4, 4, 5])
  end
end
