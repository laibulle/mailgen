defmodule MailgenTest do
  use ExUnit.Case
  doctest Mailgen

  test "greets the world" do
    assert Mailgen.hello() == :world
  end
end
