defmodule AnalyticTableaux.Sequent do
  @type t :: %__MODULE__{
          values: tuple(),
          type: :conjunction | :disjunction | :conditional | :negation | :proposition
        }

  defstruct values: {}, type: :unknown

  def stringify(%__MODULE__{type: :conjunction, values: {left, right}}) do
    "(#{stringify(left)} & #{stringify(right)})"
  end

  def stringify(%__MODULE__{type: :disjunction, values: {left, right}}) do
    "(#{stringify(left)} | #{stringify(right)})"
  end

  def stringify(%__MODULE__{type: :conditional, values: {left, right}}) do
    "(#{stringify(left)} -> #{stringify(right)})"
  end

  def stringify(%__MODULE__{type: :negation, values: {value}}) do
    "!#{stringify(value)}"
  end

  def stringify(%__MODULE__{type: :proposition, values: {value}}) do
    "#{value}"
  end
end

defimpl Inspect, for: AnalyticTableaux.Sequent do
  import Inspect.Algebra

  def inspect(sequent, _opts) do
    concat(["#AnalyticTableaux.Sequent<", AnalyticTableaux.Sequent.stringify(sequent), ">"])
  end
end
