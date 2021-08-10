defmodule AnalyticTableaux.Proposition.Simple do
  defstruct type: :simple, value: nil
end

defmodule AnalyticTableaux.Proposition.Negation do
  defstruct type: :not, proposition: nil
end

defmodule AnalyticTableaux.Proposition.Conditional do
  defstruct type: :implies, right: nil, left: nil
end

defmodule AnalyticTableaux.Proposition.Conjunction do
  defstruct type: :and, right: nil, left: nil
end

defmodule AnalyticTableaux.Proposition.Disjunction do
  defstruct type: :or, right: nil, left: nil
end

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

  defp build_struct({:simple, value}) do
    %AnalyticTableaux.Proposition.Simple{value: value}
  end

  defp build_struct({:not, proposition}) do
    %AnalyticTableaux.Proposition.Negation{proposition: build_struct(proposition)}
  end

  defp build_struct({:implies, right, left}) do
    %AnalyticTableaux.Proposition.Conditional{right: build_struct(right), left: build_struct(left)}
  end

  defp build_struct({:and, right, left}) do
    %AnalyticTableaux.Proposition.Conjunction{right: build_struct(right), left: build_struct(left)}
  end

  defp build_struct({:or, right, left}) do
    %AnalyticTableaux.Proposition.Disjunction{right: build_struct(right), left: build_struct(left)}
  end
end
