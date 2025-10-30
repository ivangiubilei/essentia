defmodule Essentia.Tokens do
  def tokenize(string) do
    string
    |> String.split()
    |> Enum.map(&classify_token/1)
  end

  defp classify_token(token) do
    cond do
      match?({_, ""}, Integer.parse(token)) ->
        {parsed, ""} = Integer.parse(token)
        {:number, parsed}

      String.starts_with?(token, "$") and String.length(token) > 1 ->
        {:str, binary_part(token, 1, byte_size(token) - 1)}

      token in ["len", "concat", "emptys"] ->
        {:str_op, String.to_atom(token)}

      token in ["true", "false"] ->
        {:bool, String.to_atom(token)}

      token in ["add", "sub", "div", "mul", "mod", "inc", "dec", "flt", "int"] ->
        {:op, String.to_atom(token)}

      token in ["eql", "gt", "gte", "lt", "lte", "and", "or", "xor", "not"] ->
        {:bool_op, String.to_atom(token)}

      token in [".", ":", ".c", ".h", ".b", ".o", "drop", "clear", "clean", "dup", "over"] ->
        {:stack_op, String.to_atom(token)}

      token in ["ife", "if"] ->
        {:keyword, String.to_atom(token)}

      token in ["end", "for"] ->
        {:loop_op, String.to_atom(token)}

      token in ["@"] ->
        {:loop_variable, String.to_atom(token)}

      true ->
        {:unrecognized, String.to_atom(token)}
    end
  end
end
