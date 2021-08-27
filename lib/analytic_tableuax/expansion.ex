defmodule AnalyticTableaux.Expansion do
  @moduledoc """
  Provides operations for expansions on analytic tableaux.
  """

  @type t :: %__MODULE__{
          status: atom(),
          sign: boolean(),
          sequent: AnalyticTableaux.Sequent.t(),
          parent: t() | nil,
          contradiction: boolean()
        }

  defstruct status: :opened, sign: nil, sequent: nil, parent: nil, contradiction: false

  @doc """
  Close an expansion.
  """
  @spec close!(t()) :: t()
  def close!(%__MODULE__{} = expansion), do: %{expansion | status: :closed}

  @doc """
  Set an expansion as open and saturated.
  """
  @spec saturate!(t()) :: t()
  def saturate!(%__MODULE__{} = expansion), do: %{expansion | status: :saturated}

  @doc """
  Define an expansion as a contradiction.
  """
  @spec contradiction!(t(), boolean()) :: t()
  def contradiction!(%__MODULE__{} = expansion, contradiction) when is_boolean(contradiction) do
    %{expansion | contradiction: contradiction}
  end

  # Build from sequent
  @doc """
  Build an expansion from a sequent without a parent expansion.
  """
  @spec build_from_sequent(boolean(), %AnalyticTableaux.Sequent{}) :: t()
  def build_from_sequent(sign, %AnalyticTableaux.Sequent{} = sequent) do
    %__MODULE__{sign: sign, sequent: sequent, parent: nil}
  end

  @doc """
  Build an expansion from a sequent with a parent expansion.
  """
  @spec build_from_sequent(boolean(), %AnalyticTableaux.Sequent{}, t()) :: t()
  def build_from_sequent(sign, %AnalyticTableaux.Sequent{} = sequent, %__MODULE__{} = parent) do
    %__MODULE__{sign: sign, sequent: sequent, parent: parent}
  end

  @doc """
  Apply expansion rules upon an instance.
  """
  @spec expand!(t()) :: [t()] | []

  # Apply expansion rules
  # Alpha conjunction

  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :conjunction, values: {left, right}}
        } = parent
      ) do
    [
      build_from_sequent(true, left, parent),
      build_from_sequent(true, right, parent)
    ]
  end

  # Alpha disjunction
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :disjunction, values: {left, right}}
        } = parent
      ) do
    [
      build_from_sequent(false, left, parent),
      build_from_sequent(false, right, parent)
    ]
  end

  # Alpha conditional
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :conditional, values: {left, right}}
        } = parent
      ) do
    [
      build_from_sequent(true, left, parent),
      build_from_sequent(false, right, parent)
    ]
  end

  # Alpha negation
  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :negation, values: {proposition}}
        } = parent
      ) do
    [
      build_from_sequent(false, proposition, parent)
    ]
  end

  # Beta conjunction
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :conjunction, values: {left, right}}
        } = parent
      ) do
    [
      build_from_sequent(false, left, parent),
      build_from_sequent(false, right, parent)
    ]
  end

  # Beta disjunction
  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :disjunction, values: {left, right}}
        } = parent
      ) do
    [
      build_from_sequent(true, left, parent),
      build_from_sequent(true, right, parent)
    ]
  end

  # Beta conditional
  def expand!(
        %__MODULE__{
          sign: true,
          sequent: %AnalyticTableaux.Sequent{type: :conditional, values: {left, right}}
        } = parent
      ) do
    [
      build_from_sequent(false, left, parent),
      build_from_sequent(true, right, parent)
    ]
  end

  # Beta negation
  def expand!(
        %__MODULE__{
          sign: false,
          sequent: %AnalyticTableaux.Sequent{type: :negation, values: {proposition}}
        } = parent
      ) do
    [
      build_from_sequent(true, proposition, parent)
    ]
  end

  # Proposition
  def expand!(%__MODULE__{sequent: %AnalyticTableaux.Sequent{type: :proposition}}), do: []
end
