defmodule AnalyticTableaux.Parser do
  def parse(str) do
    [antecedents, consequents] = str
      |> String.split("|-")

    build_struct({ :problem, antecedents, consequents })
  end

  def sub_parse(str) do
    {:ok, sequents} = str
      |> tokenize()
      |> :parser.parse()

    sequents
      |> build_struct()
  end

  defp tokenize(str) do
    {:ok, tokens, _} = str
      |> to_charlist()
      |> :lexer.string()

    tokens
  end

  defp build_struct({ :problem, antecedents, consequents }) do
    %AnalyticTableaux.Problem{
      antecedents: build_struct({ :antecedents, antecedents }),
      consequents: build_struct({ :consequents, consequents })
    }
  end

  defp build_struct({ :antecedents, antecedents }) do
    values = antecedents
      |> String.split(",")
      |> Enum.map(&sub_parse/1)

    %AnalyticTableaux.Formula.Antecedents{ values: values }
    # { :antecedents, values: values }
  end

  defp build_struct({ :consequents, consequents }) do
    values = consequents
      |> String.split(",")
      |> Enum.map(&sub_parse/1)

    %AnalyticTableaux.Formula.Consequents{ values: values }
    # { :consequents, values: values }
  end

  defp build_struct({ :proposition, value }) do
    %AnalyticTableaux.Formula.Proposition{ value: value }
    # { :proposition, value: value }
  end

  defp build_struct({ :negation, proposition }) do
    %AnalyticTableaux.Formula.Negation{ proposition: build_struct(proposition) }
    # { :negation, proposition: build_struct(proposition) }
  end

  defp build_struct({ :conditional, left, right }) do
    %AnalyticTableaux.Formula.Conditional{ left: build_struct(left), right: build_struct(right) }
    # { :conditional, left: build_struct(left), right: build_struct(right) }
  end

  defp build_struct({ :conjunction, left, right }) do
    %AnalyticTableaux.Formula.Conjunction{ left: build_struct(left), right: build_struct(right) }
    # { :conjunction, left: build_struct(left), right: build_struct(right) }
  end

  defp build_struct({ :disjunction, left, right }) do
    %AnalyticTableaux.Formula.Disjunction{ left: build_struct(left), right: build_struct(right) }
    # { :disjunction, left: build_struct(left), right: build_struct(right) }
  end
end
