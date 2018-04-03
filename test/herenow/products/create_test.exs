defmodule Herenow.Products.CreateTest do
  use Herenow.DataCase

  alias Herenow.{Products, Elasticsearch}
  alias Faker.{Name, Address, Commerce, Internet, Company, Code}
  alias Herenow.Clients.Storage.{Mutator, Loader}
  alias Herenow.Products.Product

  @valid_attrs %{
    "category" => Commerce.department(),
    "code" => Code.iban(),
    "description" => Commerce.product_name(),
    "name" => Commerce.product_name_product(),
    "price" => Commerce.price()
  }

  @index "products"
  @doc_type "product"

  def fixture(:client) do
    attrs = %{
      "street_address" => Address.street_address(),
      "latitude" => Address.latitude(),
      "longitude" => Address.longitude(),
      "is_company" => true,
      "name" => Name.name(),
      "password" => "some password",
      "legal_name" => Company.name(),
      "segment" => Commerce.department(),
      "state" => Address.state(),
      "street_name" => Address.street_name(),
      "captcha" => "valid",
      "postal_code" => "12345678",
      "city" => Address.city(),
      "email" => Internet.email()
    }

    {:ok, client} = Mutator.create(attrs)

    client
  end

  setup do
    client = fixture(:client)
    {:ok, client: client}
  end

  setup do
    {:ok, _res} = Elasticsearch.delete_index(@index)

    :ok
  end

  describe "create/1" do
    test "with valid data creates a product", %{client: client} do
      attrs =
        @valid_attrs
        |> Map.put("client_id", client.id)

      assert {:ok, %Product{} = product} = Products.create(attrs)
      assert product.category == @valid_attrs["category"]
      assert product.code == @valid_attrs["code"]
      assert product.description == @valid_attrs["description"]
      assert product.name == @valid_attrs["name"]
      assert product.price == @valid_attrs["price"]
    end

    test "handle required fields", %{client: client} do
      attrs =
        @valid_attrs
        |> Map.put("client_id", client.id)
        |> Map.delete("category")

      actual = Products.create(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "category",
              "message" => "can't be blank",
              "type" => :required
            }
          ]}}

      assert actual == expected
    end

    test "handle invalid foreign keys" do
      attrs =
        @valid_attrs
        |> Map.put("client_id", 1)

      actual = Products.create(attrs)

      expected =
        {:error,
         {:validation,
          [
            %{
              "field" => "client_id",
              "message" => "does not exist",
              "type" => :not_exists
            }
          ]}}

      assert actual == expected
    end

    test "should add the product to elasticsearch", %{client: client} do
      attrs =
        @valid_attrs
        |> Map.put("client_id", client.id)

      assert {:ok, %Product{} = product} = Products.create(attrs)

      {:ok, response} = Elasticsearch.get_data(@index, @doc_type, product.id)
      body = response.body

      assert response.status_code == 200

      {:ok, location} = Loader.get_location(client.id)
      assert body["_source"]["client_id"] == client.id
      assert body["_source"]["category"] == product.category
      assert body["_source"]["description"] == product.description
      assert body["_source"]["name"] == product.name
      assert body["_source"]["price"] == product.price

      assert body["_source"]["location"] == %{
               "lat" => location.latitude,
               "lon" => location.longitude
             }

      assert body["_source"]["updated_at"] == NaiveDateTime.to_iso8601(product.updated_at)
      assert body["_source"]["inserted_at"] == NaiveDateTime.to_iso8601(product.inserted_at)
    end
  end
end
