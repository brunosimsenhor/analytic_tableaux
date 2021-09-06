defmodule AnalyticTableauxTest do
  use ExUnit.Case

  TestHelpers.SequentExamples.valid()
  |> Enum.each(fn sequent ->
    @tag sequent: sequent
    @tag :pending
    test "The sequent #{sequent} is valid", context do
      assert %{status: :valid} = Prover.prove(context.sequent)
    end
  end)

  TestHelpers.SequentExamples.invalid()
  |> Enum.each(fn sequent ->
    @tag sequent: sequent
    @tag :pending
    test "The sequent #{sequent} is NOT valid", context do
      assert %{status: :not_valid} = Prover.prove(context.sequent)
    end
  end)

  test "provable problem" do
    assert %{status: :valid} = Prover.prove("p, (p | q) -> r |- r")
  end

  test "unprovable problem" do
    assert %{status: :not_valid} = Prover.prove("p, (p & q) -> r |- r")
  end
end
