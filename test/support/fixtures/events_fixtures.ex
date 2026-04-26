defmodule Bludo.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bludo.Events` context.
  """

  import Bludo.{AccountsFixtures}

  require Bludo.UtilFixture

  @doc """
  Generate an activity leader.
  """
  def activity_leader_fixture(attrs \\ %{}, preload \\ []) do
    assoc = %{
      event: attrs[:event] || event_fixture(),
      user: attrs[:user] || user_fixture()
    }

    {:ok, activity_leader} =
      attrs
      |> Enum.into(%{
        email: assoc.user.email,
        event_id: assoc.event.id
      })
      |> Bludo.Events.create_activity_leader()

    Bludo.UtilFixture.merge_preload(activity_leader, preload, assoc)
  end

  @doc """
  Generate an event.
  """
  def event_fixture(attrs \\ %{}, preload \\ []) do
    assoc = %{user: attrs[:user] || user_fixture()}

    {:ok, event} =
      attrs
      |> Enum.into(%{
        name: "some name",
        code: :crypto.strong_rand_bytes(4) |> Base.url_encode64() |> binary_part(0, 8),
        uuid: Ecto.UUID.generate(),
        user_id: assoc.user.id,
        started_at: NaiveDateTime.utc_now(),
        expired_at: nil
      })
      |> Bludo.Events.create_event()

    Bludo.UtilFixture.merge_preload(event, preload, assoc)
  end
end


