defmodule Essentia.EmptyStackError do
  defexception message: "Empty stack"
end

defmodule Essentia.ForNotClosedError do
  defexception message: "Missing end token"
end

defmodule Essentia.NotStringError do
  defexception message: "Targets not strings"
end

defmodule Essentia.UnknownTokenError do
  defexception [:token]

  def message(%{token: token}),
    do: "Unrecognized token: #{token}"
end
