defmodule Bludo.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bludo.Posts` context.
  """

  import Bludo.{AccountsFixtures, EventsFixtures}

  require Bludo.UtilFixture

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}, preload \\ []) do
    user = attrs[:user] || user_fixture()
    event = attrs[:event] || event_fixture()
    assoc = %{user: user, event: event}

    {:ok, post} =
      Bludo.Posts.create_post(
        assoc.event,
        attrs
        |> Enum.into(%{
          body: "some body",
          like_count: 42,
          position: 0,
          uuid: Ecto.UUID.generate(),
          user_id: assoc.user.id
        })
      )

    Bludo.UtilFixture.merge_preload(post, preload, assoc)
  end

  @doc """
  Generate a reaction.
  """
  def reaction_fixture(attrs \\ %{}) do
    {:ok, reaction} =
      attrs
      |> Enum.into(%{
        icon: "some icon"
      })
      |> Bludo.Posts.create_reaction()

    reaction
  end
end


