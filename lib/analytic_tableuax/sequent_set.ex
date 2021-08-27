defmodule AnalyticTableaux.SequentSet do
  defstruct values: [], type: :unknown

  def new(values, type) when is_list(values) and type in [:antecedents, :consequents] do
    %__MODULE__{type: type, values: values}
  end
end
