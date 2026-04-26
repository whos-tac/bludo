defmodule Bludo.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          uuid: Ecto.UUID.t(),
          name: String.t() | nil,
          code: String.t(),
          audience_peak: integer() | nil,
          started_at: NaiveDateTime.t(),
          expired_at: NaiveDateTime.t() | nil,
          posts: [Bludo.Posts.Post.t()] | nil,
          leaders: [Bludo.Events.ActivityLeader.t()] | nil,
          presentation_file: Bludo.Presentations.PresentationFile.t() | nil,
          user: Bludo.Accounts.User.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "events" do
    field :uuid, :binary_id
    field :name, :string
    field :code, :string
    field :audience_peak, :integer, default: 0
    field :started_at, :naive_datetime
    field :expired_at, :naive_datetime

    has_many :posts, Bludo.Posts.Post
    has_many :leaders, Bludo.Events.ActivityLeader, on_replace: :delete

    has_one :presentation_file, Bludo.Presentations.PresentationFile
    has_one :lti_resource, Lti13.Resources.Resource

    belongs_to :user, Bludo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :code,
      :started_at,
      :expired_at,
      :audience_peak,
      :user_id
    ])
    |> cast_assoc(:presentation_file)
    |> cast_assoc(:leaders)
    |> validate_required([:name, :code, :started_at])
  end

  def create_changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :code, :user_id, :started_at, :expired_at])
    |> cast_assoc(:presentation_file)
    |> cast_assoc(:leaders)
    |> validate_required([:name, :code, :started_at, :user_id])
    |> validate_length(:code, min: 5, max: 10)
    |> validate_length(:name, min: 5, max: 50)
    |> downcase_code
    |> put_change(:uuid, Ecto.UUID.generate())
  end

  def downcase_code(changeset) do
    update_change(
      changeset,
      :code,
      &(&1 |> String.downcase() |> String.split(~r"[^\w\d]", trim: true) |> List.first())
    )
  end

  def update_changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :code, :started_at, :expired_at, :audience_peak, :user_id])
    |> cast_assoc(:presentation_file)
    |> cast_assoc(:leaders)
    |> validate_required([:name, :code, :started_at, :user_id])
    |> validate_length(:code, min: 5, max: 10)
    |> validate_length(:name, min: 5, max: 50)
    |> downcase_code
  end

  def restart_changeset(event) do
    expiry =
      NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> NaiveDateTime.add(48 * 3600)

    change(event, expired_at: expiry)
  end

  def subscribe(event_uuid) do
    Phoenix.PubSub.subscribe(Bludo.PubSub, "event:#{event_uuid}")
  end

  def started?(event) do
    NaiveDateTime.compare(NaiveDateTime.utc_now(), event.started_at) == :gt
  end

  def finished?(event) do
    event.expired_at && NaiveDateTime.compare(NaiveDateTime.utc_now(), event.expired_at) == :gt
  end
end



