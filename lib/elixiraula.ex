defmodule Elixiraula do
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
        :error
    end
  end
end
