defmodule Herenow.Core.ErrorMessageTest do
  use ExUnit.Case, async: true

  alias Herenow.Core.ErrorMessage

  describe "create/2" do
    test "should return a tuple" do
      assert {:error, {:type, "message"}} == ErrorMessage.create(:type, "message")
    end
  end
end
