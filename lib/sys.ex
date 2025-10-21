defmodule Sys do
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
    Py.generate_and_run_fractal(result, 10, 25)
  end
end
