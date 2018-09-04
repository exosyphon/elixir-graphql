defmodule PastexWeb.Schema.ContentTypes do
  use Absinthe.Schema.Notation

  alias PastexWeb.ContentResolver

  @desc "Blobs of Pasted code"
  object :paste do
    field :name, non_null(:string)
    field :description, :string
    @desc "A paste can contain multiple files"
    field :files, non_null(list_of(:file)) do
      resolve &ContentResolver.get_files/3
    end
    field :id, non_null(:id)
  end

  object :file do
    field :name, :string do
      resolve fn file, _, _ ->
        {:ok , Map.get(file, :name) || "Untitled"}
      end
    end
    field :body, :string do
      arg :style, :body_style
      resolve &ContentResolver.format_body/3
    end
    field :paste, non_null(:paste)
  end

  enum :body_style do
    value :formatted
    value :original
  end

  object :content_queries do
    field :pastes, list_of(non_null(:paste)) do
      resolve &ContentResolver.list_pastes/3
    end
  end

  object :content_mutations do
    field :create_paste, :paste do
      arg :input, non_null(:create_paste_input)
      resolve &ContentResolver.create_paste/3
    end
  end

  object :content_subscriptions do
    field :paste_created, :paste do
      config fn _, _ ->
        {:ok, topic: "*"}
      end

      trigger [:create_paste],
        topic: fn _paste ->
          "*"
        end
    end
  end

  input_object :create_paste_input do
    field :name, non_null(:string)
    field :description, :string
    field :files, non_null(list_of(non_null(:file_input)))
  end

  input_object :file_input do
    field :name, :string
    field :body, :string
  end
end
