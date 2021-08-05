defmodule AnalyticTableaux.Parser do
  def parse(str) do
    {:ok, sequent} = str
        |> tokenize()
        |> :parser.parse()
    sequent
  end

  defp tokenize(str) do
    {:ok, tokens, _} = str
      |> to_charlist()
      |> :lexer.string()

    tokens
  end
end
