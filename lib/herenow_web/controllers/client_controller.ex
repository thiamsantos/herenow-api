defmodule HerenowWeb.ClientController do
  use HerenowWeb, :controller

  alias Herenow.Clients

  action_fallback(HerenowWeb.FallbackController)

  # {
  # @apiDefine DefaultHeader
  # @apiHeader Content-Type application/json.
  # }

  # {
  # @apiDefine AuthenticationHeader
  # @apiHeader Authorization Bearer YOUR_TOKEN.
  # }

  # {
  # @apiDefine MissingRequiredKeysError
  # @apiError MissingRequiredKeys Missing required keys
  # @apiErrorExample MissingRequiredResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "code": 100,
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "can't be blank",
  #           "field": "city",
  #           "code": 104
  #         }
  #       ]
  #     }
  # }

  # {
  # @apiDefine InvalidKeyTypeError
  # @apiError InvalidKeyType Invalid key type
  # @apiErrorExample InvalidKeyTypeResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "is invalid",
  #           "field": "email",
  #           "code": 102
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine InvalidCaptchaError
  # @apiError InvalidCaptcha Invalid recaptcha code
  # @apiErrorExample InvalidCaptchaResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "Invalid captcha",
  #           "field": null,
  #           "code": 101
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine EmailAlreadyTakenError
  # @apiError EmailAlreadyTaken Email already taken
  # @apiErrorExample EmailAlreadyTakenResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "has already been taken",
  #           "field": "email",
  #           "code": 107
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine LongEmailError
  # @apiError LongEmail Email too long
  # @apiErrorExample LongEmailResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "should be at most 254 character(s)",
  #           "field": "email",
  #           "code": 103
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine InvalidEmailFormatError
  # @apiError InvalidEmailFormat Invalid has a invalid format
  # @apiErrorExample InvalidEmailFormatResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "has invalid format",
  #           "field": "email",
  #           "code": 106
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine InvalidPostCodeError
  # @apiError InvalidPostCode Postal code has the wrong length
  # @apiErrorExample InvalidPostCodeResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "should be 8 character(s)",
  #           "field": "postal_code",
  #           "code": 103
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine WeakPasswordError
  # @apiError WeakPassword Password is too short
  # @apiErrorExample WeakPasswordResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "should be at least 8 character(s)",
  #           "field": "password",
  #           "code": 103
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine InvalidSignatureError
  # @apiError InvalidSignature Token has an invalid signature
  # @apiErrorExample InvalidSignatureResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "Invalid signature",
  #           "field": null,
  #           "code": 108
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine ExpiredTokenError
  # @apiError ExpiredToken Token has expired
  # @apiErrorExample ExpiredTokenResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "Expired token",
  #           "field": null,
  #           "code": 109
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine ClientNotRegisteredError
  # @apiError ClientNotRegistered Client is not registered
  # @apiErrorExample ClientNotRegisteredResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "does not exist",
  #           "field": "client_id",
  #           "code": 110
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine ClientAlreadyVerifiedError
  # @apiError ClientAlreadyVerified Client is not registered
  # @apiErrorExample ClientAlreadyVerifiedResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "has already been taken",
  #           "field": "client_id",
  #           "code": 107
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine UsedTokenError
  # @apiError UsedToken Token was already used.
  # @apiErrorExample UsedTokenResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "message": "Validation failed!",
  #       "errors": [
  #         {
  #           "message": "has already been taken",
  #           "field": null,
  #           "code": 111
  #         }
  #       ],
  #       "code": 100
  #     }
  # }

  # {
  # @apiDefine CurrentPasswordError
  # @apiError CurrentPassword Wrong current password.
  # @apiErrorExample CurrentPasswordResponse:
  #     HTTP/1.1 401 Unauthorized
  #     {
  #       "message": "Authorization failed!",
  #       "errors": [
  #         {
  #           "message": "Invalid password",
  #           "code": 303
  #         }
  #       ],
  #       "code": 300
  #     }
  # }

  # {
  # @api {post} /clients Register client
  # @apiName CreateClient
  # @apiGroup Client
  #
  # @apiParam {String} email Client's email.
  # @apiParam {String} password Client's password.
  # @apiParam {String} name Client's full name.
  # @apiParam {String} legal_name Client's legal name.
  # @apiParam {Boolean} is_company Client is a company?
  # @apiParam {String} segment Client's market segment.
  # @apiParam {String} postal_code Client's postal code.
  # @apiParam {String} latitude Client's latitude.
  # @apiParam {String} longitude Client's longitude.
  # @apiParam {String} street_address Client's street address.
  # @apiParam {String} city Client's city.
  # @apiParam {String} state Client's state.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSuccess {Number} id Client's unique ID.
  # @apiSuccess {String} email Client's email.
  # @apiSuccess {String} name Client's full name.
  # @apiSuccess {String} legal_name Client's legal name.
  # @apiSuccess {Boolean} is_company Client is a company?
  # @apiSuccess {String} segment Client's market segment.
  # @apiSuccess {String} postal_code Client's postal code.
  # @apiSuccess {String} latitude Client's latitude.
  # @apiSuccess {String} longitude Client's longitude.
  # @apiSuccess {String} street_address Client's street address.
  # @apiSuccess {String} city Client's city.
  # @apiSuccess {String} state Client's state.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 201 Created
  #     {
  #       "id": 16,
  #       "email": "john@gmail.com",
  #       "name": "John",
  #       "legal_name": "John INC",
  #       "is_company": true,
  #       "segment": "john@gmail.com",
  #       "postal_code": "88813000",
  #       "latitude": 27.5,
  #       "latitude": 9.3,
  #       "street_address": "Baker Street 221 B",
  #       "city": "São Paulo",
  #       "state": "London"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse InvalidCaptchaError
  # @apiUse EmailAlreadyTakenError
  # @apiUse LongEmailError
  # @apiUse InvalidEmailFormatError
  # @apiUse InvalidPostCodeError
  # @apiUse WeakPasswordError
  # }

  def create(conn, client_params) do
    with {:ok, client} <- Clients.register(client_params) do
      conn
      |> put_status(:created)
      |> render("show.json", client: client)
    end
  end

  # {
  # @api {post} /verified-clients Verify client
  # @apiName VerifyClient
  # @apiGroup Client
  #
  # @apiParam {String} token Token sent by email to verify client.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSuccess {Number} id Client's unique ID.
  # @apiSuccess {String} email Client's email.
  # @apiSuccess {String} name Client's full name.
  # @apiSuccess {String} legal_name Client's legal name.
  # @apiSuccess {Boolean} is_company Client is a company?
  # @apiSuccess {String} segment Client's market segment.
  # @apiSuccess {String} postal_code Client's postal code.
  # @apiSuccess {String} latitude Client's latitude.
  # @apiSuccess {String} longitude Client's longitude.
  # @apiSuccess {String} street_address Client's street address.
  # @apiSuccess {String} city Client's city.
  # @apiSuccess {String} state Client's state.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "id": 16,
  #       "email": "john@gmail.com",
  #       "name": "John",
  #       "legal_name": "John INC",
  #       "is_company": true,
  #       "segment": "john@gmail.com",
  #       "postal_code": "88813000",
  #       "latitude": 27.5,
  #       "latitude": 9.3,
  #       "street_address": "Baker Street 221 B",
  #       "city": "São Paulo",
  #       "state": "London"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse InvalidCaptchaError
  # @apiUse InvalidSignatureError
  # @apiUse ExpiredTokenError
  # @apiUse ClientNotRegisteredError
  # @apiUse ClientAlreadyVerifiedError
  # }
  def verify(conn, params) do
    with {:ok, client} <- Clients.activate(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", client: client)
    end
  end

  # {
  # @api {post} /clients/request-activation Request client activation email
  # @apiName RequestClientActivation
  # @apiGroup Client
  #
  # @apiSuccess {String} email Client's email.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSuccess {String} message API message.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "message": "Email successfully sended!"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse InvalidCaptchaError
  # @apiUse LongEmailError
  # @apiUse InvalidEmailFormatError
  # }
  def request_activation(conn, params) do
    with {:ok, response} <- Clients.request_activation(params) do
      conn
      |> put_status(:ok)
      |> render("rpc_response.json", response: response)
    end
  end

  # {
  # @api {post} /clients/recover-password Recover client password
  # @apiName RecoverClientPassword
  # @apiGroup Client
  #
  # @apiParam {String} token Token sent by email to recover the password.
  # @apiParam {String} password Client's new password.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSuccess {Number} id Client's unique ID.
  # @apiSuccess {String} email Client's email.
  # @apiSuccess {String} name Client's full name.
  # @apiSuccess {String} legal_name Client's legal name.
  # @apiSuccess {Boolean} is_company Client is a company?
  # @apiSuccess {String} segment Client's market segment.
  # @apiSuccess {String} postal_code Client's postal code.
  # @apiSuccess {String} latitude Client's latitude.
  # @apiSuccess {String} longitude Client's longitude.
  # @apiSuccess {String} street_address Client's street address.
  # @apiSuccess {String} city Client's city.
  # @apiSuccess {String} state Client's state.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "id": 16,
  #       "email": "john@gmail.com",
  #       "name": "John",
  #       "legal_name": "John INC",
  #       "is_company": true,
  #       "segment": "john@gmail.com",
  #       "postal_code": "88813000",
  #       "latitude": 27.5,
  #       "latitude": 9.3,
  #       "street_address": "Baker Street 221 B",
  #       "city": "São Paulo",
  #       "state": "London"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse InvalidCaptchaError
  # @apiUse InvalidSignatureError
  # @apiUse ExpiredTokenError
  # @apiUse UsedTokenError
  # @apiUse WeakPasswordError
  # }
  def recover_password(conn, params) do
    with {:ok, client} <- Clients.recover_password(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", client: client)
    end
  end

  # {
  # @api {post} /clients/password-recovery Request a password recovery token
  # @apiName RequestPasswordRecovery
  # @apiGroup Client
  #
  # @apiParam {String} email Client's email.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSuccess {String} message API message.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "message": "Email successfully sended!"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse InvalidCaptchaError
  # @apiUse LongEmailError
  # @apiUse InvalidEmailFormatError
  # }
  def request_password_recovery(conn, params) do
    user_agent = %{
      "operating_system" => Browser.full_platform_name(conn),
      "browser_name" => Browser.name(conn)
    }

    request = Map.merge(params, user_agent)

    with {:ok, response} <- Clients.request_password_recovery(request) do
      conn
      |> put_status(:ok)
      |> render("rpc_response.json", response: response)
    end
  end

  # {
  # @api {post} /profile/password Update a client's password
  # @apiName UpdatePassword
  # @apiGroup Client
  #
  # @apiParam {String} current_password Client's current password.
  # @apiParam {String} password Client's password.
  #
  # @apiSuccess {Number} id Client's unique ID.
  # @apiSuccess {String} email Client's email.
  # @apiSuccess {String} name Client's full name.
  # @apiSuccess {String} legal_name Client's legal name.
  # @apiSuccess {Boolean} is_company Client is a company?
  # @apiSuccess {String} segment Client's market segment.
  # @apiSuccess {String} postal_code Client's postal code.
  # @apiSuccess {String} latitude Client's latitude.
  # @apiSuccess {String} longitude Client's longitude.
  # @apiSuccess {String} street_address Client's street address.
  # @apiSuccess {String} city Client's city.
  # @apiSuccess {String} state Client's state.
  # @apiSuccessExample Success-Response:
  #     HTTP/1.1 200 OK
  #     {
  #       "id": 16,
  #       "email": "john@gmail.com",
  #       "name": "John",
  #       "legal_name": "John INC",
  #       "is_company": true,
  #       "segment": "john@gmail.com",
  #       "postal_code": "88813000",
  #       "latitude": 27.5,
  #       "latitude": 9.3,
  #       "street_address": "Baker Street 221 B",
  #       "city": "São Paulo",
  #       "state": "London"
  #     }
  #
  # @apiUse DefaultHeader
  # @apiUse AuthenticationHeader
  # @apiUse MissingRequiredKeysError
  # @apiUse InvalidKeyTypeError
  # @apiUse WeakPasswordError
  # @apiUse CurrentPasswordError
  # }
  def update_password(conn, params) do
    params =
      params
      |> Map.put("client_id", conn.assigns[:client_id])

    with {:ok, client} <- Clients.update_password(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", client: client)
    end
  end
end
