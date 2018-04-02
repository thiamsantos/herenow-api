defmodule Herenow.Clients.Storage.Fields do
  @moduledoc """
  Shared fields that a client has
  """

  @required_fields [
    :email,
    :password,
    :name,
    :is_company,
    :segment,
    :postal_code,
    :street_name,
    :street_number,
    :city,
    :state,
    :lat,
    :lon
  ]

  def required_fields, do: @required_fields

  @optional_fields [
    :legal_name
  ]

  def optional_fields, do: @optional_fields
end
