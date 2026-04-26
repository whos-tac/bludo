defmodule Bludo.Polls.PollVote do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          attendee_identifier: String.t() | nil,
          poll_id: integer() | nil,
          poll_opt_id: integer() | nil,
          user_id: integer() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "poll_votes" do
    field :attendee_identifier, :string

    belongs_to :poll, Bludo.Polls.Poll
    belongs_to :poll_opt, Bludo.Polls.PollOpt
    belongs_to :user, Bludo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(poll_vote, attrs) do
    poll_vote
    |> cast(attrs, [:attendee_identifier, :user_id, :poll_opt_id, :poll_id])
    |> validate_required([:poll_opt_id, :poll_id])
  end
end



