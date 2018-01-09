defmodule PhxdemoWeb.UserView do
  use PhxdemoWeb, :view
  alias PhxdemoWeb.UserView
  import Joken

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    secret = Application.get_env(:phxdemo, :secret)

    my_token = %{user_id: 1}
    |> token
    |> with_signer(hs256(secret))
    |> sign
    |> get_compact

    %{id: user.id,
      name: user.name,
      age: user.age,
      my_token: my_token
    }
  end
end
