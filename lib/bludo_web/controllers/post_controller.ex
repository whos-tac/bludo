defmodule BludoWeb.PostController do
  use BludoWeb, :controller

  def index(conn, %{"event_id" => event_id}) do
    try do
      with event <- Bludo.Events.get_event!(event_id),
           posts <- Bludo.Posts.list_posts(event.uuid, [:user, :attendee]) do
        render(conn, "index.json", posts: posts)
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> put_view(BludoWeb.ErrorView)
        |> render(:"404")
    end
  end

  def create(conn, %{"event_id" => event_id, "body" => body}) do
    try do
      with event <- Bludo.Events.get_event!(event_id) do
        case Bludo.Posts.create_post(event, %{body: body}) do
          {:ok, post} -> render(conn, "post.json", post: post)
        end
      end
    rescue
      Ecto.NoResultsError ->
        conn
        |> put_status(:not_found)
        |> put_view(BludoWeb.ErrorView)
        |> render(:"404")
    end
  end
end



