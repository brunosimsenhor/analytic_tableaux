defmodule AnalyticTableaux.Prover do
  @moduledoc """
  A module to structure an analytic tableaux problem.
  """

  @doc """
  Start the validation process of a given problem.
  """
  @spec valid?(AnalyticTableaux.Problem.t()) :: [AnalyticTableaux.Expansion.t()]
  def valid?(%AnalyticTableaux.Problem{} = problem) do
    problem
    |> build_struct()
    |> expand!()
  end

  # Expand!
  # The header function, to insert a default value for state.
  defp expand!(expansions, state \\ [])

  # When the remainder is empty, we just return the processed state.
  defp expand!([], state), do: state

  # Here, we use tail recursion to apply expansion rules to the head
  defp expand!([head | tail], state) do
    head = AnalyticTableaux.Expansion.close!(head)

    new_expansions = AnalyticTableaux.Expansion.expand!(head)
    #   |> check_for_contradictions(head)

    # case Enum.all?(new_expansions, fn i -> contradiction?(i, state ++ [head | tail]) end) do
    #   true -> expand!([], [state | head] ++ new_expansions) # force recursion interuption
    #   false -> expand!(tail ++ new_expansions, [state | head])
    # end

    # expand!(tail ++ new_expansions, state ++ [head])

    expand!(tail ++ new_expansions, [head | state])
  end

  # defp check_for_contradictions(expansions, parent) do
  #   expansions
  #     |> Enum.map(fn e -> AnalyticTableaux.Expansion.contradiction!(e, contradiction?(e, state)) end)
  # end

  # Build 
  defp build_struct(%AnalyticTableaux.Problem{antecedents: antecedents, consequents: consequents}) do
    build_struct(antecedents) ++ build_struct(consequents)
  end

  # Structure a sequent set (antecedents and consequents) into an array of structured expansions.
  defp build_struct(%AnalyticTableaux.SequentSet{type: type, values: sequents}) do
    sequents
    |> Enum.map(fn f -> AnalyticTableaux.Expansion.build_from_sequent(type == :antecedents, f) end)
  end
end
