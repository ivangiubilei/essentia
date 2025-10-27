defmodule EssentiaTest do
  use ExUnit.Case

  test "creates a new stack" do
    assert Essentia.Stack.new() == %Essentia.Stack{stack: []}
  end

  test "push to stack" do
    stack = Essentia.Stack.new()

    assert Essentia.Stack.push(stack, 9) == %Essentia.Stack{stack: [9]}
  end

  test "multiple push to stack" do
    stack = Essentia.Stack.new()

    assert Essentia.Stack.push_multiple(stack, [1, 2, :add]) == %Essentia.Stack{
             stack: [:add, 2, 1]
           }
  end
end
