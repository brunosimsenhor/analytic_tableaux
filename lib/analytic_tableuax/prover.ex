defmodule AnalyticTableaux.Prover do
  def valid?(%AnalyticTableaux.Problem{ antecedents: antecedents, consequents: consequents }) do
    raise "must be implemented"
  end

  def valid?(%AnalyticTableaux.Formula.Antecedents{ values: values }, state) do
    raise "must be implemented"
  end

  def valid?(%AnalyticTableaux.Formula.Consequents{ values: values }, state) do
    raise "must be implemented"
  end

  def valid?(%AnalyticTableaux.Formula.Conditional{ left: left, right: right }, state) do
    raise "must be implemented"
  end

  def valid?(%AnalyticTableaux.Formula.Conjunction{ left: left, right: right }, state) do
    raise "must be implemented"
  end

  def valid?(%AnalyticTableaux.Formula.Disjunction{ left: left, right: right }, state) do
    raise "must be implemented"
  end

  def valid?(%AnalyticTableaux.Formula.Negation{ proposition: proposition }, state) do
    raise "must be implemented"
  end
end
