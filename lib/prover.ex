defmodule Prover do
  defstruct status: :unknown

  def prove(string) do
    string
    |> AnalyticTableaux.Parser.parse_problem
    |> AnalyticTableaux.Prover.prove!
  end

  def get_status(%__MODULE__{status: status}) do
    status
  end
end
