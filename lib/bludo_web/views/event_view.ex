defmodule BludoWeb.EventView do
  use BludoWeb, :view

  def render("show.json", %{event: event}) do
    %{data: render_one(event, BludoWeb.EventView, "event.json")}
  end

  def render("event.json", %{event: event}) do
    %{
      uuid: event.uuid,
      name: event.name,
      posts: render_many(event.posts, BludoWeb.PostView, "post.json")
    }
  end
end



