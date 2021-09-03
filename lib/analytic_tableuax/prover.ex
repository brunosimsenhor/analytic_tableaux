defmodule AnalyticTableaux.Prover do
  @moduledoc """
  A module to structure an analytic tableaux problem.
  """

  def validate_solvable_problem! do
    valid?(AnalyticTableaux.Parser.solvable_problem())
  end

  def solve_solvable_problem! do
    solve!(AnalyticTableaux.Parser.solvable_problem())
  end

  def validate_unsolvable_problem! do
    valid?(AnalyticTableaux.Parser.unsolvable_problem())
  end

  def solve_unsolvable_problem! do
    solve!(AnalyticTableaux.Parser.unsolvable_problem())
  end

  @doc """
  Solves a given problem.
  """
  @spec solve!(AnalyticTableaux.Problem.t()) :: [AnalyticTableaux.Expansion.t()]
  def solve!(%AnalyticTableaux.Problem{} = problem) do
    problem
    |> build_struct
    |> prove!
    |> Enum.reject(&AnalyticTableaux.Expansion.initial_data?(&1))
    |> Enum.reverse()
  end

  @doc """
  Validates a given problem.
  """
  @spec valid?(AnalyticTableaux.Problem.t()) :: boolean()
  def valid?(%AnalyticTableaux.Problem{} = problem) do
    problem
    |> solve!
    |> Enum.any?(&AnalyticTableaux.Expansion.saturated?(&1))
    |> Kernel.!()
  end

  # Prove!
  # The header function, to insert a default value for state.
  defp prove!(expansions, state \\ [])

  # When the initial state is empty, we force the first expansions as it's state
  defp prove!(expansions, []) do
    prove!(
      expansions,
      expansions |> Enum.map(fn x -> AnalyticTableaux.Expansion.initial_data!(x) end)
    )
  end

  # When the remainder is empty, we just return the processed state.
  defp prove!([], state), do: state

  # Here, we use tail recursion to apply expansion rules to the head
  defp prove!([head | tail], state) do
    {head, _, new_expansions} = AnalyticTableaux.Expansion.expand!(head, state)

    prove!(tail ++ new_expansions, [head | state])
  end

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
