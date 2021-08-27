defmodule AnalyticTableaux.Sequent do
  @type t :: %__MODULE__{
          values: tuple(),
          type: :conjunction | :disjunction | :conditional | :negation | :proposition
        }

  defstruct values: {}, type: :unknown
end
