defmodule PastexWeb.ContentResolver do
  alias Pastex.Content

  def list_pastes(_, _, _) do
    {:ok, Content.list_pastes()}
  end

  def get_files(paste, _, _) do
    files =
      paste
      |> Ecto.assoc(:files)
      |> Pastex.Repo.all()

    {:ok, files}
  end

  def format_body(file, arguments, _) do
    case arguments do
      %{style: :formatted} ->
        {:ok, Code.format_string!(file.body)}

        _ ->
          {:ok, file.body}
      end
  end

  def create_paste(_, %{input: input}, _) do
    case Content.create_paste(input) do
      {:ok, paste} ->
        {:ok, paste}
      {:error, _} ->
        {:error, "didn't work"}
    end
  end
end
