defmodule AnalyticTableaux.Parser do
  @moduledoc """
  Provides parsing for analytic tableaux.
  """

  @doc """
  Build a solvable problem into a complex struct of sequents.
  """
  @spec provable_problem() :: AnalyticTableaux.Problem.t()
  def provable_problem() do
    parse_problem("p, (p | q) -> r |- r")
  end

  @doc """
  Build a solvable problem into a complex struct of sequents.
  """
  @spec unprovable_problem() :: AnalyticTableaux.Problem.t()
  def unprovable_problem() do
    parse_problem("p, (p & q) -> r |- r")
  end

  @doc """
  Parse a problem into a complex struct of sequents.
  """
  @spec parse_problem(String.t()) :: AnalyticTableaux.Problem.t()
  def parse_problem(str) do
    [antecedents, consequents] = String.split(str, "|-")

    build_struct({:problem, antecedents, consequents})
  end

  @doc """
  Parse a string into a structured sequent.
  """
  @spec parse_sequent(String.t()) :: AnalyticTableaux.Sequent.t()
  def parse_sequent(str) do
    {:ok, sequents} =
      str
      |> tokenize()
      |> :parser.parse()

    sequents
    |> build_struct()
  end

  defp tokenize(str) do
    {:ok, tokens, _} =
      str
      |> to_charlist()
      |> :lexer.string()

    tokens
  end

  defp build_struct({:problem, antecedents, consequents}) do
    %AnalyticTableaux.Problem{
      antecedents: build_struct({:antecedents, antecedents}),
      consequents: build_struct({:consequents, consequents})
    }
  end

  # Structuring the problem antecedents and consequents
  defp build_struct({type, sequents}) when type in [:antecedents, :consequents] do
    sequents
    |> String.split(",")
    |> Enum.map(&parse_sequent/1)
    |> AnalyticTableaux.SequentSet.new(type)
  end

  # Structuring propositions, an unary case.
  # Propositions don't need to be recursively structured.
  defp build_struct({:proposition, proposition}) do
    %AnalyticTableaux.Sequent{type: :proposition, values: {proposition}}
  end

  # Structuring negations, an unary case.
  defp build_struct({:negation, proposition}) do
    %AnalyticTableaux.Sequent{type: :negation, values: {build_struct(proposition)}}
  end

  # Structuring binary cases: conditionals, conjunctions and disjunctions.
  defp build_struct({type, left, right})
       when type in [:conditional, :conjunction, :disjunction] do
    %AnalyticTableaux.Sequent{type: type, values: {build_struct(left), build_struct(right)}}
  end
end
