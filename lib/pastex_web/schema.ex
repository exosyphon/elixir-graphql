defmodule PastexWeb.Schema do
  use Absinthe.Schema

  alias PastexWeb.ContentResolver

  import_types PastexWeb.Schema.ContentTypes

  query do
    field :health, :string do
      resolve(fn _, _, _ ->
        {:ok, "up"}
      end)
    end

    import_fields :content_queries
  end

  mutation do
    import_fields :content_mutations
  end
end
