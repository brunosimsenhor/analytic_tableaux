defmodule AnalyticTableaux.SignedFormula do
  @moduledoc """
  Provides operations for expansions on analytic tableaux.
  """

  @type t :: %__MODULE__{
          status: atom(),
          sign: boolean(),
          sequent: AnalyticTableaux.Sequent.t(),
          root: boolean(),
          expanded: boolean(),
          contradiction: boolean(),
          branches: [t()]
        }

  defstruct status: :opened,
            sign: nil,
            sequent: nil,
            root: false,
            contradiction: false,
            expanded: false,
            branches: []

  @doc """
  Checks if an expansion is closed.
  """
  @spec closed?(t()) :: boolean()
  def closed?(%__MODULE__{status: :closed}), do: true
  def closed?(%__MODULE__{}), do: false

  @doc """
  Close an expansion.
  """
  @spec close!(t()) :: t()
  def close!(%__MODULE__{} = expansion) do
    %{expansion | status: :closed}
  end

  @doc """
  Checks if an expansion is opened and saturated.
  """
  @spec saturated?(t()) :: boolean()
  def saturated?(%__MODULE__{status: :saturated}), do: true
  def saturated?(%__MODULE__{}), do: false

  @doc """
  Set an expansion as open and saturated.
  """
  @spec saturate!(t()) :: t()
  def saturate!(%__MODULE__{} = expansion), do: %{expansion | status: :saturated}

  @doc """
  Checks if an expansion is a contradiction.
  """
  @spec contradiction?(t()) :: boolean()
  def contradiction?(%__MODULE__{contradiction: contradiction}), do: contradiction

  @doc """
  Define an expansion as a contradiction status.
  """
  @spec contradiction!(t(), boolean()) :: t()
  def contradiction!(%__MODULE__{} = expansion, contradiction),
    do: %{expansion | contradiction: contradiction}

  @doc """
  Define an expansion as expanded.
  """
  @spec expanded!(t()) :: t()
  def expanded!(%__MODULE__{} = expansion),
    do: %{expansion | expanded: true}

  @doc """
  Define an expansion as a contradiction status.
  If it is a contradiction, it is also closed.
  """
  @spec initial_data!(t()) :: t()
  def initial_data!(%__MODULE__{} = expansion) do
    %{expansion | status: :initial_data}
  end

  @doc """
  Checks if an expansion is an 'initial data'.
  """
  @spec initial_data!(t()) :: boolean()
  def initial_data?(%__MODULE__{status: :initial_data}), do: true
  def initial_data?(%__MODULE__{status: _}), do: false

  # Build from sequent
  @doc """
  Build an expansion from a sequent without a root expansion.
  """
  @spec build_from_sequent(boolean(), %AnalyticTableaux.Sequent{}) :: t()
  def build_from_sequent(sign, %AnalyticTableaux.Sequent{} = sequent) do
    %__MODULE__{sign: sign, sequent: sequent, root: true}
  end

  @doc """
  Build an expansion from a sequent with a root expansion.
  """
  @spec build_from_sequent(boolean(), %AnalyticTableaux.Sequent{}, t()) :: t()
  def build_from_sequent(sign, %AnalyticTableaux.Sequent{} = sequent, %__MODULE__{} = _root) do
    %__MODULE__{sign: sign, sequent: sequent, root: false}
  end

  @doc """
  Get the rule type based on the formula.
  """
  @spec rule_type(t()) :: :linear | :branching
  def rule_type(%__MODULE__{sign: true, sequent: %AnalyticTableaux.Sequent{type: :conjunction}}),
    do: :linear

  def rule_type(%__MODULE__{sign: false, sequent: %AnalyticTableaux.Sequent{type: :disjunction}}),
    do: :linear

  def rule_type(%__MODULE__{sign: false, sequent: %AnalyticTableaux.Sequent{type: :conditional}}),
    do: :linear

  def rule_type(%__MODULE__{sign: _, sequent: %AnalyticTableaux.Sequent{type: :negation}}),
    do: :linear

  def rule_type(%__MODULE__{sign: _, sequent: %AnalyticTableaux.Sequent{type: :proposition}}),
    do: :linear

  def rule_type(%__MODULE__{sign: false, sequent: %AnalyticTableaux.Sequent{type: :conjunction}}),
    do: :branching

  def rule_type(%__MODULE__{sign: true, sequent: %AnalyticTableaux.Sequent{type: :disjunction}}),
    do: :branching

  def rule_type(%__MODULE__{sign: true, sequent: %AnalyticTableaux.Sequent{type: :conditional}}),
    do: :branching

  defp treat_expansion!(%__MODULE__{} = expansion, branches, state) do
    %{expansion | expanded: true}
    |> check_contradictions!(state)
    |> change_expansion_status!(rule_type(expansion), branches)
  end

  @doc """
  Apply expansion rules upon an instance.
  """
  @spec expand!(t(), [t()]) :: {t(), [t()]} | []

  # Expansion rules

  # Proposition
  def expand!(%__MODULE__{sequent: %AnalyticTableaux.Sequent{type: :proposition}} = root, state) do
    {treat_expansion!(root, [], state), [], []}
  end

  # Linear: true conjunction
  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :conjunction, values: {left, right}}
        } = root,
        state
      ) do
    {left_branch, _, _} = build_from_sequent(true, left, root) |> expand!(state)
    {right_branch, _, _} = build_from_sequent(true, right, root) |> expand!(state)

    branches = [
      left_branch,
      right_branch,
    ]

    {treat_expansion!(root, branches, state), branches, branches}
  end

  # Linear: false disjunction
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :disjunction, values: {left, right}}
        } = root,
        state
      ) do
    {left_branch, _, _} = build_from_sequent(false, left, root) |> expand!(state)
    {right_branch, _, _} = build_from_sequent(false, right, root) |> expand!(state)

    branches = [
      left_branch,
      right_branch,
    ]

    {treat_expansion!(root, branches, state), branches, branches}
  end

  # Linear: false conditional
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :conditional, values: {left, right}}
        } = root,
        state
      ) do
    {left_branch, _, _} = build_from_sequent(true, left, root) |> expand!(state)
    {right_branch, _, _} = build_from_sequent(false, right, root) |> expand!(state)

    branches = [
      left_branch,
      right_branch,
    ]

    {treat_expansion!(root, branches, state), branches, branches}
  end

  # Linear: negations
  def expand!(
        %__MODULE__{
          sign: sign,
          sequent: %AnalyticTableaux.Sequent{type: :negation, values: {proposition}}
        } = root,
        state
      ) do
    {only_branch, _, _} = build_from_sequent(!sign, proposition, root) |> expand!(state)

    branches = [
      only_branch,
    ]

    {treat_expansion!(root, branches, state), branches, branches}
  end

  # Branching: false conjunction
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :conjunction, values: {left, right}}
        } = root,
        state
      ) do
    {left_branch, _, _} = build_from_sequent(false, left, root) |> expand!(state)
    {right_branch, _, _} = build_from_sequent(false, right, root) |> expand!(state)

    branches = [
      left_branch,
      right_branch,
    ]

    root = treat_expansion!(%{root | branches: branches}, branches, state)

    {root, branches, []}
  end

  # Branching: true disjunction
  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :disjunction, values: {left, right}}
        } = root,
        state
      ) do
    {left_branch, _, _} = build_from_sequent(true, left, root) |> expand!(state)
    {right_branch, _, _} = build_from_sequent(true, right, root) |> expand!(state)

    branches = [
      left_branch,
      right_branch,
    ]

    root = treat_expansion!(%{root | branches: branches}, branches, state)

    {root, branches, []}
  end

  # Branching: true conditional
  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :conditional, values: {left, right}}
        } = root,
        state
      ) do
    {left_branch, _, _} = build_from_sequent(false, left, root) |> expand!(state)
    {right_branch, _, _} = build_from_sequent(true, right, root) |> expand!(state)

    branches = [
      left_branch,
      right_branch,
    ]

    root = treat_expansion!(%{root | branches: branches}, branches, state)

    {root, branches, []}
  end

  # Changing expansions statuses
  # Closing root propositions
  defp change_expansion_status!(
         %__MODULE__{root: true} = expansion,
         :linear,
         _
       ) do
    close!(expansion)
  end

  # Non-contradiction proposition
  defp change_expansion_status!(
         %__MODULE__{
           root: false,
           contradiction: false,
           sequent: %AnalyticTableaux.Sequent{type: :proposition}
         } = expansion,
         :linear,
         []
       ), do: saturate!(expansion)

  # Contradiction proposition
  defp change_expansion_status!(
         %__MODULE__{contradiction: true} = expansion,
         :linear,
         _
       ), do: close!(expansion)

  # Contradiction proposition
  defp change_expansion_status!(
         %__MODULE__{contradiction: true} = expansion,
         :branching,
         [%{contradiction: left}, %{contradiction: right}]
       ) when true in [left, right], do: close!(expansion)

  # Linear
  defp change_expansion_status!(
         %__MODULE__{
           root: false,
           contradiction: false,
         } = expansion,
         :linear,
         _
       ), do: close!(expansion)

  # Branching
  # When any of the inside branches are saturared.
  defp change_expansion_status!(
         %__MODULE__{contradiction: false} = expansion,
         :branching,
         [%{status: left}, %{status: right}]
       ) when :saturated in [left, right], do: saturate!(expansion)

  # When both inside branches are closed, we close the current branch.
  defp change_expansion_status!(
         %__MODULE__{contradiction: false} = expansion,
         :branching,
         [%{status: :closed}, %{status: :closed}]
       ), do: close!(expansion)

  # Checks for contradictions in a given expansion against the current state.
  defp check_contradictions!(%__MODULE__{sequent: %AnalyticTableaux.Sequent{type: :proposition}} = expansion, state) do
    contradiction!(
      expansion,
      Enum.any?(state, &contradicting_expansions?(&1, expansion))
    )
  end

  defp check_contradictions!(%__MODULE__{} = expansion, _), do: expansion

  # This matches only when the sequents are equals (OMG).
  defp contradicting_expansions?(
         %__MODULE__{sign: l_sign, sequent: sequent},
         %__MODULE__{sign: r_sign, sequent: sequent}
       ) do
    l_sign != r_sign
  end

  defp contradicting_expansions?(_, _), do: false

  # Debug functions
  def stringify(%__MODULE__{sign: true, sequent: sequent}) do
    "T " <> AnalyticTableaux.Sequent.stringify(sequent)
  end

  def stringify(%__MODULE__{sign: false, sequent: sequent}) do
    "F " <> AnalyticTableaux.Sequent.stringify(sequent)
  end
end
