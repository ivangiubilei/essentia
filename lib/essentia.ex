defmodule Essentia do
  def repl do
    loop(Essentia.Stack.new())
  end

  defp loop(stack) do
    input = IO.gets("essentia-repl> ")

    case input do
      nil ->
        IO.puts("goodbye!")
        :ok

      input ->
        input = String.trim(input)

        if input == "" do
          loop(stack)
        else
          tokens = Essentia.Tokens.tokenize(input)

          try do
            new_stack = Essentia.Parser.parse(stack, tokens)
            IO.puts("Stack: #{inspect(Enum.reverse(new_stack.stack), charlists: :as_lists)}")
            loop(new_stack)
          rescue
            _e in Essentia.EmptyStackError ->
              IO.puts("Error: stack is empty: nothing to pop or operate on.")
              loop(stack)

            e in Essentia.UnknownTokenError ->
              IO.puts("#{Exception.message(e)}")
              loop(stack)

            e ->
              IO.puts("Unexpected error: #{Exception.message(e)}")
              loop(stack)
          end
        end
    end
  end
end
