defmodule Sys do
  def l_system(axiom, rules) when is_map(rules) do
    axiom
    |> Enum.flat_map(fn x -> Map.get(rules, x, [x]) end)
  end

  def l_system_stochastic(axiom, rules) do
    axiom
    |> Enum.flat_map(fn x ->
      case Map.get(rules, x) do
        rules_list when is_list(rules_list) ->
          total_weight = Enum.sum(Enum.map(rules_list, fn {_rule, weight} -> weight end))
          random_val = :rand.uniform()

          {_, selected_rule} =
            Enum.reduce(rules_list, {0.0, nil}, fn {rule, weight}, {cumulative, selected} ->
              normalized_prob = weight / total_weight
              new_cumulative = cumulative + normalized_prob

              if selected == nil and random_val <= new_cumulative do
                {new_cumulative, rule}
              else
                {new_cumulative, selected}
              end
            end)

            # Enum.reduce_while(rules_list, {0.0, nil}, fn {rule, weight}, {cumulative, _} ->
            #   normalized_prob = weight / total_weight
            #   new_cumulative = cumulative + normalized_prob

            #   if random_val <= new_cumulative do
            #     {:halt, {new_cumulative, rule}}
            #   else
            #     {:cont, {new_cumulative, nil}}
            #   end
            # end)

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

  def execute_system(config) do
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

    if compare_lystem(config, result) do
      IO.puts("Fractal generated correctly!")
    else
      IO.puts("Fractal generated incorrectly!")
    end
  end

  def compare_lystem(config, g_string) do
    axiom = String.graphemes(config.axiom)
    result = case config.type do
      "deterministic" ->
        Sys.l_system_iter(axiom, config.rules, config.iterations)
      "stochastic" ->
        Sys.l_system_iter_stochastic(axiom, config.rules, config.iterations)
    end |> Enum.join("")
    result == g_string
  end


  def runner() do
    # Inicializar o gerador de números aleatórios
    :rand.seed(:exs1024, {123, 456, 789})

    Configfile.read()
    config = Configfile.read()
    execute_system(config)

  end
end
