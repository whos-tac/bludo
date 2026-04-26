defmodule Bludo.PresentationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bludo.Presentations` context.
  """

  import Bludo.{EventsFixtures}

  require Bludo.UtilFixture

  @doc """
  Generate a presentation_file.
  """
  def presentation_file_fixture(attrs \\ %{}, preload \\ []) do
    assoc = %{event: attrs[:event] || event_fixture(attrs)}

    {:ok, presentation_file} =
      attrs
      |> Enum.into(%{
        hash: "123456",
        length: 42,
        status: "done",
        event_id: assoc.event.id
      })
      |> Bludo.Presentations.create_presentation_file()

    Bludo.UtilFixture.merge_preload(presentation_file, preload, assoc)
  end

  @doc """
  Generate a presentation_state.
  """
  def presentation_state_fixture(attrs \\ %{}, preload \\ []) do
    assoc = %{presentation_file: attrs[:presentation_file] || presentation_file_fixture()}

    {:ok, presentation_state} =
      attrs
      |> Enum.into(%{
        presentation_file_id: assoc.presentation_file.id,
        position: 0,
        banned: [],
        chat_visible: false,
        poll_visible: false,
        join_screen_visible: false
      })
      |> Bludo.Presentations.create_presentation_state()

    Bludo.UtilFixture.merge_preload(presentation_state, preload, assoc)
  end
end


