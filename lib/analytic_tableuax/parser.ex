defmodule AnalyticTableaux.Parser do
  def parse(str) do
    {:ok, sequent} = str
        |> tokenize()
        |> :parser.parse()
      
    sequent
      |> build_struct()
  end

  defp tokenize(str) do
    {:ok, tokens, _} = str
      |> to_charlist()
      |> :lexer.string()

    tokens
  end

  defp build_struct({:proposition, value}) do
    %AnalyticTableaux.Formula.Proposition{value: value}
  end

  defp build_struct({:negation, proposition}) do
    %AnalyticTableaux.Formula.Negation{proposition: build_struct(proposition)}
  end

  defp build_struct({:conditional, left, right}) do
    %AnalyticTableaux.Formula.Conditional{left: build_struct(left), right: build_struct(right)}
  end

  defp build_struct({:conjunction, left, right}) do
    %AnalyticTableaux.Formula.Conjunction{left: build_struct(left), right: build_struct(right)}
  end

  defp build_struct({:disjunction, left, right}) do
    %AnalyticTableaux.Formula.Disjunction{left: build_struct(left), right: build_struct(right)}
  end
end
