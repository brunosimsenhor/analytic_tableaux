defmodule AnalyticTableaux.Prover do
  @moduledoc """
  A module to structure an analytic tableaux problem.
  """

  def prove_provable_problem! do
    AnalyticTableaux.Parser.provable_problem
    |> prove!
  end

  def prove_unprovable_problem! do
    AnalyticTableaux.Parser.unprovable_problem
    |> prove!
  end

  def validate_provable_problem! do
    AnalyticTableaux.Parser.provable_problem
    |> valid?
  end

  def validate_unprovable_problem! do
    AnalyticTableaux.Parser.unprovable_problem
    |> valid?
  end

  @doc """
  Solves a given problem.
  """
  @spec prove!(AnalyticTableaux.Problem.t()) :: [AnalyticTableaux.SignedFormula.t()]
  def prove!(%AnalyticTableaux.Problem{} = problem) do
    problem
    |> build_struct
    |> expand!
    |> Enum.reject(&AnalyticTableaux.SignedFormula.initial_data?(&1))
    |> Enum.reverse()
  end

  @doc """
  Validates a given problem.
  """
  @spec valid?(AnalyticTableaux.Problem.t()) :: boolean()
  def valid?(%AnalyticTableaux.Problem{} = problem) do
    [head | tail] =
      problem
      |> prove!

    prover_format(head, tail)
  end

  # When the last closed signed formula is found, the problem is invalid.
  defp prover_format(%AnalyticTableaux.SignedFormula{status: :saturated}, _) do
    %Prover{status: :not_valid}
  end

  # When the last closed signed formula is found, the problem is valid.
  defp prover_format(%AnalyticTableaux.SignedFormula{status: :closed}, []) do
    %Prover{status: :valid}
  end

  # Some tail recursion to iterate through our tableaux.
  defp prover_format(%AnalyticTableaux.SignedFormula{status: :closed}, [head | tail]) do
    prover_format(head, tail)
  end

  # Prove!
  # The header function, to insert a default value for state.
  defp expand!(expansions, state \\ [])

  # When the initial state is empty, we force the first expansions as it's state
  defp expand!(expansions, []) do
    expand!(
      expansions,
      expansions |> Enum.map(fn x -> AnalyticTableaux.SignedFormula.initial_data!(x) end)
    )
  end

  # When the remainder is empty, we just return the processed state.
  defp expand!([], state), do: state

  # Here, we use tail recursion to apply expansion rules to the head
  defp expand!([head | tail], state) do
    {head, _, new_expansions} = AnalyticTableaux.SignedFormula.expand!(head, state)

    expand!(tail ++ new_expansions, [head | state])
  end

  # Build
  defp build_struct(%AnalyticTableaux.Problem{antecedents: antecedents, consequents: consequents}) do
    build_struct(antecedents) ++ build_struct(consequents)
  end

  # Structure a sequent set (antecedents and consequents) into an array of structured expansions.
  defp build_struct(%AnalyticTableaux.SequentSet{type: type, values: sequents}) do
    sequents
    |> Enum.map(fn f -> AnalyticTableaux.SignedFormula.build_from_sequent(type == :antecedents, f) end)
  end
end
