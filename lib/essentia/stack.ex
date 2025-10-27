defmodule Essentia.Stack do
  alias Essentia.Stack
  defstruct stack: []
  @type t :: %__MODULE__{stack: list(any())}

  @spec new() :: t()
  def new() do
    %Stack{stack: []}
  end

  @spec push(t(), any()) :: t()
  def push(%Stack{stack: s}, value), do: %Stack{stack: [value | s]}

  @spec pop(t()) :: {any(), t()}
  def pop(%Stack{stack: []}), do: raise(Essentia.EmptyStackError)
  def pop(%Stack{stack: [h | t]}), do: {h, %Stack{stack: t}}
end
