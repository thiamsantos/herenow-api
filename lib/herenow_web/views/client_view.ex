defmodule HerenowWeb.ClientView do
  use HerenowWeb, :view

  def render("show.json", %{client: client}) do
    %{
      id: client.id,
      email: client.email,
      name: client.name,
      legal_name: client.legal_name,
      segment: client.segment,
      latitude: client.latitude,
      longitude: client.longitude,
      postal_code: client.postal_code,
      city: client.city,
      is_company: client.is_company,
      state: client.state,
      street_address: client.street_address
    }
  end

  def render("rpc_response.json", %{response: response}) do
    %{message: response.message}
  end
end
