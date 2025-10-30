defmodule Essentia.Utils.For do
  alias Essentia.Stack

  def pop_until(stack), do: _pop_until(stack, [], 0)

  defp _pop_until(%Stack{stack: []}, _acc, _), do: raise(Essentia.ForNotClosedError)

  defp _pop_until(stack, acc, 0) do
    {val, new_stack} = Stack.pop(stack)

    case val do
      :end -> {acc, new_stack}
      :for -> _pop_until(new_stack, [val | acc], 1)
      _ -> _pop_until(new_stack, [val | acc], 0)
    end
  end

  defp _pop_until(stack, acc, count) do
    {val, new_stack} = Stack.pop(stack)

    case val do
      :end -> _pop_until(new_stack, [val | acc], count - 1)
      :for -> _pop_until(new_stack, [val | acc], count + 1)
      _ -> _pop_until(new_stack, [val | acc], count)
    end
  end
end
