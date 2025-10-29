defmodule Essentia.Parser do
  def parse(stack, []), do: stack

  def parse(stack, [{:number, el} | t]) do
    parse(Essentia.Stack.push(stack, el), t)
  end

  def parse(stack, [{:str, el} | t]) do
    parse(Essentia.Stack.push(stack, el), t)
  end

  def parse(_stack, [{:stack_op, :clear} | t]) do
    parse(Essentia.Stack.new(), t)
  end

  def parse(_stack, [{:stack_op, :clean} | t]) do
    parse(Essentia.Stack.new(), t)
  end

  def parse(stack, [{:bool, el} | t]) do
    parse(Essentia.Stack.push(stack, el), t)
  end

  def parse(stack, [{:op, :flt} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token / 1), t)
  end

  def parse(stack, [{:op, :int} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, trunc(token)), t)
  end

  def parse(stack, [{:stack_op, :dup} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)
    stack = Essentia.Stack.push(stack, token)
    stack = Essentia.Stack.push(stack, token)

    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :over} | t]) do
    {a, stack} = Essentia.Stack.pop(stack)
    {b, stack} = Essentia.Stack.pop(stack)

    stack = Essentia.Stack.push(stack, b)
    stack = Essentia.Stack.push(stack, a)
    stack = Essentia.Stack.push(stack, b)

    parse(stack, t)
  end

  def parse(stack, [{:op, :add} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 + token1), t)
  end

  def parse(stack, [{:op, :sub} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 - token1), t)
  end

  def parse(stack, [{:op, :mul} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 * token1), t)
  end

  def parse(stack, [{:op, :div} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 / token1), t)
  end

  def parse(stack, [{:op, :mod} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, rem(token2, token1)), t)
  end

  def parse(stack, [{:op, :inc} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token1 + 1), t)
  end

  def parse(stack, [{:op, :dec} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token1 - 1), t)
  end

  def parse(stack, [{:bool_op, :eql} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 == token1), t)
  end

  def parse(stack, [{:bool_op, :gt} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 > token1), t)
  end

  def parse(stack, [{:bool_op, :gte} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 >= token1), t)
  end

  def parse(stack, [{:bool_op, :lt} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 < token1), t)
  end

  def parse(stack, [{:bool_op, :lte} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 <= token1), t)
  end

  def parse(stack, [{:bool_op, :and} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 and token1), t)
  end

  def parse(stack, [{:bool_op, :or} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)
    {token2, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, token2 or token1), t)
  end

  def parse(stack, [{:bool_op, :xor} | t]) do
    {a, stack} = Essentia.Stack.pop(stack)
    {b, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, (a && !b) || (b && !a)), t)
  end

  def parse(stack, [{:bool_op, :not} | t]) do
    {token1, stack} = Essentia.Stack.pop(stack)

    parse(Essentia.Stack.push(stack, !token1), t)
  end

  def parse(stack, [{:str_op, :concat} | t]) do
    {a, stack} = Essentia.Stack.pop(stack)
    {b, stack} = Essentia.Stack.pop(stack)

    unless is_bitstring(a) or is_bitstring(b) do
      raise Essentia.NotStringError
    end

    parse(Essentia.Stack.push(stack, b <> a), t)
  end

  def parse(stack, [{:str_op, :emptys} | t]) do
    parse(Essentia.Stack.push(stack, " "), t)
  end

  def parse(stack, [{:str_op, :len} | t]) do
    {a, stack} = Essentia.Stack.pop(stack)

    unless is_bitstring(a) do
      raise Essentia.NotStringError
    end

    parse(Essentia.Stack.push(stack, String.length(a)), t)
  end

  def parse(stack, [{:stack_op, :.} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)
    IO.puts(token)
    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :":"} | t]) do
    {a, stack} = Essentia.Stack.pop(stack)
    {b, stack} = Essentia.Stack.pop(stack)

    stack = Essentia.Stack.push(stack, a)
    stack = Essentia.Stack.push(stack, b)

    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :drop} | t]) do
    {_token, stack} = Essentia.Stack.pop(stack)
    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :".h"} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)
    IO.puts(Integer.to_string(token, 16))
    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :".o"} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)
    IO.puts(Integer.to_string(token, 8))
    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :".b"} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)
    IO.puts(Integer.to_string(token, 2))
    parse(stack, t)
  end

  def parse(stack, [{:stack_op, :".c"} | t]) do
    {token, stack} = Essentia.Stack.pop(stack)
    IO.write(<<token::utf8>> <> "\n")
    parse(stack, t)
  end

  def parse(stack, [{:keyword, :if} | t]) do
    {cond, stack} = Essentia.Stack.pop(stack)
    {then, stack} = Essentia.Stack.pop(stack)

    if cond do
      parse(Essentia.Stack.push(stack, then), t)
    else
      parse(stack, t)
    end
  end

  def parse(stack, [{:keyword, :ife} | t]) do
    {cond, stack} = Essentia.Stack.pop(stack)
    {then, stack} = Essentia.Stack.pop(stack)
    {else_, stack} = Essentia.Stack.pop(stack)

    if cond do
      parse(Essentia.Stack.push(stack, then), t)
    else
      parse(Essentia.Stack.push(stack, else_), t)
    end
  end

  def parse(_stack, [{:unrecognized, token} | _t]),
    do: raise(Essentia.UnknownTokenError, token: token)
end
