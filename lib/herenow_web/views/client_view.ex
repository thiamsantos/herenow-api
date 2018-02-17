defmodule HerenowWeb.ClientView do
  use HerenowWeb, :view

  def render("show.json", %{client: client}) do
    %{
      id: client.id,
      email: client.email,
      name: client.name,
      legal_name: client.legal_name,
      segment: client.segment,
      address_number: client.address_number,
      cep: client.cep,
      city: client.city,
      is_company: client.is_company,
      state: client.state,
      street: client.street
    }
  end
end
