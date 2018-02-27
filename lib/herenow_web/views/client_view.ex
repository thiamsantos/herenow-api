defmodule HerenowWeb.ClientView do
  use HerenowWeb, :view

  def render("show.json", %{client: client}) do
    %{
      id: client.id,
      email: client.email,
      name: client.name,
      legal_name: client.legal_name,
      segment: client.segment,
      street_number: client.street_number,
      postal_code: client.postal_code,
      city: client.city,
      is_company: client.is_company,
      state: client.state,
      street_name: client.street_name
    }
  end

  def render("request_activation_send.json", %{response: response}) do
    %{message: response.message}
  end
end
