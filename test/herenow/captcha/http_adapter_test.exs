defmodule Herenow.Captcha.HTTPAdapterTest do
  use ExUnit.Case, async: true

  alias Herenow.Captcha.HTTPAdapter

  @moduletag :recaptcha_api

  describe "verify/2" do
    test "should return ok" do
      Application.put_env(:recaptcha, :secret, "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe")
      assert {:ok} == HTTPAdapter.verify("valid")
    end

    test "should return error" do
      Application.put_env(:recaptcha, :secret, "invalid")

      assert {:error, {:unprocessable_entity, "Invalid captcha"}} == HTTPAdapter.verify("invalid")
    end
  end
end
