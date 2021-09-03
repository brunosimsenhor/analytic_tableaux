defmodule TreeTest do
  use ExUnit.Case

  @tag :skip
  test "A new tree with one node p is not nil" do
    assert Tree.new("p") != nil
  end

  @tag :skip
  test "You cannot create new tree with one node for a number" do
    assert Tree.new("p") != nil

    assert_raise FunctionClauseError, fn ->
      Tree.new(1)
    end
  end
end
