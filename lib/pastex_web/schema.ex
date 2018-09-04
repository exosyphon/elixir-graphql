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
    field :files, non_null(list_of(:file)) do
      resolve &get_files/3
    end
  end

  object :file do
    field :paste_id, :integer
    field :name, :string do
      resolve fn file, _, _ ->
        {:ok , Map.get(file, :name) || "Untitled"}
      end
    end
    field :body, :string
    field :paste, non_null(:paste) do
      resolve &get_paste_from_file/3
    end
  end

  @pastes [
    %{
      id: 1,
      name: "Hello World"
    },
    %{
      id: 2,
      name: "Help!",
      description: "I don't know what I'm doing!!"
    }
  ]

  @files [
    %{
      paste_id: 1,
      body: ~s[IO.puts("Hello World")]
    },
    %{
      paste_id: 2,
      name: "foo.ex",
      body: """
      defmodule Foo do
        def foo, do: Bar.bar()
      end
      """
    },
    %{
      paste_id: 2,
      name: "bar.ex",
      body: """
      defmodule Bar do
        def bar, do: Foo.foo()
      end
      """
    }
  ]

  defp list_pastes(root_value, _, _) do
    root_value |> IO.inspect label: "root_value"
    IO.puts "Executing Pastes"
    {:ok, @pastes}
  end

  defp get_files(paste, _, _) do
    IO.puts "Executing get files"
    IO.inspect paste
    files = Enum.filter(@files, fn file -> file.paste_id == paste.id end)
    {:ok, files}
  end

  defp get_paste_from_file(file, _, _) do
    {:ok, Enum.find(@pastes, fn paste -> paste.id == file.paste_id end)}
  end
end
