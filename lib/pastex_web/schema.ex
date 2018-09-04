defmodule PastexWeb.Schema do
  use Absinthe.Schema

  query do
    field :health, :string do
      resolve(fn _, _, _ ->
        IO.puts "health"
        {:ok, "up"}
      end)
    end

    field :pastes, list_of(non_null(:paste)) do
      resolve &list_pastes/3
    end
  end

  @desc "Blobs of Pasted code"
  object :paste do
    field :name, non_null(:string)
    field :description, :string
    @desc "A paste can contain multiple files"
    field :files, non_null(list_of(:file))
  end

  object :file do
    field :name, :string
    field :body, :string
    field :paste, non_null(:paste)
  end

  @pastes [
    %{
      name: "Hello World",
      files: [
        %{
          body: ~s[IO.puts("Hello World")]
        }
      ]
    },
    %{
      name: "Help!",
      description: "I don't know what I'm doing!!",
      files: [
        %{
          name: "foo.ex",
          body: """
          defmodule Foo do
            def foo, do: Bar.bar()
          end
          """
        },
        %{
          name: "bar.ex",
          body: """
          defmodule Bar do
            def bar, do: Foo.foo()
          end
          """
        }
      ]
    }
  ]

  def list_pastes(_, _, _) do
    IO.puts "Executing Pastes"
    {:ok, @pastes}
  end
end
