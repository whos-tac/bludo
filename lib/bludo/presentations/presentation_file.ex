defmodule Bludo.Presentations.PresentationFile do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          hash: String.t() | nil,
          length: integer() | nil,
          status: String.t() | nil,
          event_id: integer() | nil,
          polls: [Bludo.Polls.Poll.t()] | nil,
          forms: [Bludo.Forms.Form.t()] | nil,
          embeds: [Bludo.Embeds.Embed.t()] | nil,
          quizzes: [Bludo.Quizzes.Quiz.t()] | nil,
          presentation_state: Bludo.Presentations.PresentationState.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "presentation_files" do
    field :hash, :string
    field :length, :integer
    field :status, :string

    belongs_to :event, Bludo.Events.Event
    has_many :polls, Bludo.Polls.Poll
    has_many :forms, Bludo.Forms.Form
    has_many :embeds, Bludo.Embeds.Embed
    has_many :quizzes, Bludo.Quizzes.Quiz
    has_one :presentation_state, Bludo.Presentations.PresentationState, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(presentation_file, attrs) do
    presentation_file
    |> cast(attrs, [:length, :status, :hash, :event_id])
    |> cast_assoc(:presentation_state)
  end
end



