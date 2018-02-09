defmodule Herenow.Core.ErrorMessageTest do
  use ExUnit.Case, async: true

  alias Herenow.Core.ErrorMessage

  test "create/2 should return a tuple" do
    assert {:error, {:type, %{"message" => "message"}}} = ErrorMessage.create(:type, "message")
  end
end
