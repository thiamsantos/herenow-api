defmodule HerenowWeb.ClientController do
  use HerenowWeb, :controller

  alias Herenow.Clients

  action_fallback(HerenowWeb.FallbackController)

  # {
  # @apiDefine DefaultHeader
  # @apiHeader Content-Type application/json.
  # }

  # {
  # @apiDefine MissingRequiredKeysError
  # @apiError MissingRequiredKeys Missing required keys
  # @apiErrorExample MissingRequiredResponse:
  #   HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "Missing required keys: [\"city\", \"email\"]"
  #     }
  # }

  # {
  # @apiDefine InvalidKeyTypeError
  # @apiError InvalidKeyType Invalid key type
  # @apiErrorExample InvalidKeyTypeResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "Expected STRING, got INTEGER 9, at email"
  #     }
  # }

  # {
  # @apiDefine InvalidCaptchaError
  # @apiError InvalidCaptcha Invalid recaptcha code
  # @apiErrorExample InvalidCaptchaResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "Invalid captcha"
  #     }
  # }

  # {
  # @apiDefine EmailAlreadyTakenError
  # @apiError EmailAlreadyTaken Email already taken
  # @apiErrorExample EmailAlreadyTakenResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "\"email\" has already been taken"
  #     }
  # }

  # {
  # @apiDefine LongEmailError
  # @apiError LongEmail Email too long
  # @apiErrorExample LongEmailResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "\"email\" should be at most 254 character(s)"
  #     }
  # }

  # {
  # @apiDefine InvalidEmailFormatError
  # @apiError InvalidEmailFormat Invalid has a invalid format
  # @apiErrorExample InvalidEmailFormatResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "\"email\" has invalid format"
  #     }
  # }

  # {
  # @apiDefine InvalidPostCodeError
  # @apiError InvalidPostCode Postal code has the wrong length
  # @apiErrorExample InvalidPostCodeResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "\"postal_code\" should be 8 character(s)"
  #     }
  # }

  # {
  # @apiDefine ShortPasswordError
  # @apiError ShortPassword Password is too short
  # @apiErrorExample ShortPasswordResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "\"password\" should be at least 8 characters"
  #     }
  # }

  # {
  # @apiDefine InvalidSchemaError
  # @apiError InvalidSchema Body has wrong schema
  # @apiErrorExample InvalidSchemaResponse:
  #     HTTP/1.1 422 Unprocessable Entity
  #     {
  #       "statusCode": 422,
  #       "error": "Unprocessable Entity",
  #       "message": "Invalid schema"
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
  # @apiParam {String} street_name Client's street name.
  # @apiParam {String} street_number Client's street number.
  # @apiParam {String} city Client's city.
  # @apiParam {String} state Client's state.
  # @apiParam {String} captcha Recaptcha code.
  #
  # @apiSucesss {Number} id Client's unique ID.
  # @apiSucesss {String} email Client's email.
  # @apiSucesss {String} name Client's full name.
  # @apiSucesss {String} legal_name Client's legal name.
  # @apiSucesss {Boolean} is_company Client is a company?
  # @apiSucesss {String} segment Client's market segment.
  # @apiSucesss {String} postal_code Client's postal code.
  # @apiSucesss {String} street_name Client's street name.
  # @apiSucesss {String} street_number Client's street number.
  # @apiSucesss {String} city Client's city.
  # @apiSucesss {String} state Client's state.
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
  #       "street_number": "221 B",
  #       "street_name": "Baker Street",
  #       "city": "São Paulo,
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
  # @apiUse ShortPasswordError
  # }

  def create(conn, client_params) do
    with {:ok, client} <- Clients.register(client_params) do
      conn
      |> put_status(:created)
      |> render("show.json", client: client)
    end
  end
end
