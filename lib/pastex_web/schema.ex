defmodule PastexWeb.Schema do
  use Absinthe.Schema

  query do
    field :health, :string do
      resolve(fn _, _, _ ->
        {:ok, "up"}
      end)
    end

    field :explode, :string do
      resolve(fn _, _, _ ->
        {:error, "kaboom!"}
      end)
    end
  end
end
