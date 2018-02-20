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

      actual = HTTPAdapter.verify("invalid")
      expected = {:error,
             {:validation,
              [
                %{
                  "field" => nil,
                  "message" => "Invalid captcha",
                  "type" => :invalid_captcha
                }
              ]}}

      assert actual == expected
    end
  end
end
