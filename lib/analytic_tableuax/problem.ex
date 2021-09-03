defmodule AnalyticTableaux.Problem do
  @moduledoc """
  A structure to the analytic tableaux problem.
  """

  @type t :: %__MODULE__{
          antecedents: [AnalyticTableaux.Sequent.t()],
          consequents: [AnalyticTableaux.Sequent.t()]
        }

  defstruct antecedents: nil, consequents: nil
end
