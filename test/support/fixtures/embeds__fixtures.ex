defmodule Bludo.EmbedsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bludo.Embeds` context.
  """

  require Bludo.UtilFixture

  @doc """
  Generate a embed.
  """
  def embed_fixture(attrs \\ %{}, preload \\ []) do
    {:ok, embed} =
      attrs
      |> Enum.into(%{
        title: "some title",
        content:
          "<iframe src=\"https://www.youtube.com/embed/9bZkp7q19f0\" frameborder=\"0\" allowfullscreen></iframe>",
        position: 0,
        provider: "custom",
        enabled: true,
        attendee_visibility: true
      })
      |> Bludo.Embeds.create_embed()

    Bludo.UtilFixture.merge_preload(embed, preload, %{})
  end

  def embed_youtube_fixture(attrs \\ %{}, preload \\ []) do
    {:ok, embed} =
      attrs
      |> Enum.into(%{
        title: "some title",
        content: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        position: 1,
        provider: "youtube",
        enabled: true,
        attendee_visibility: true
      })
      |> Bludo.Embeds.create_embed()

    Bludo.UtilFixture.merge_preload(embed, preload, %{})
  end
end


