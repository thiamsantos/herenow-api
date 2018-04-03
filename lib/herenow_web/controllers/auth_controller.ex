defmodule HerenowWeb.AuthController do
  use HerenowWeb, :controller

  alias Herenow.Clients

  action_fallback(HerenowWeb.FallbackController)

  # {
  # @apiDefine InvalidCredentialsError
  # @apiError InvalidCredentials Invalid credentials.
  # @apiErrorExample InvalidCredentialsResponse:
  #     HTTP/1.1 401 Unauthorized
  #     {
  #       "message": "Authorization failed!",
  #       "errors": [
  #         {
  #           "message": "Invalid credentials",
  #           "code": 301
  #         }
  #       ],
  #       "code": 300
  #     }
  # }

  # {
  # @apiDefine AccountUnverifiedError
  # @apiError AccountUnverified Account was not verified.
  # @apiErrorExample AccountUnverifiedResponse:
  #     HTTP/1.1 401 Unauthorized
  #     {
  #       "message": "Authorization failed!",
  #       "errors": [
  #         {
  #           "message": "Account not verified",
  #           "code": 302
  #         }
  #       ],
  #       "code": 300
  #     }
  # }

  # {
  # @api {post} /auth/identity request an access token
  # @apiName Authenticate
  # @apiGroup Authentication
  #
  # @apiParam {String} email Client's email.
  # @apiParam {String} password Client's password.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSuccess {String} token Access token.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 201 CREATED
  #     {
  #       "token": "eyJzdWIiOiIxMjM0NTY3ODkw.XbPfbIHMI6arZ3Y922BhjWo"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse InvalidCaptchaError
  # @apiUse LongEmailError
  # @apiUse InvalidEmailFormatError
  # @apiUse InvalidCredentialsError
  # @apiUse AccountUnverifiedError
  # }
  def create(conn, params) do
    with {:ok, token} <- Clients.authenticate(params) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    end
  end
end
