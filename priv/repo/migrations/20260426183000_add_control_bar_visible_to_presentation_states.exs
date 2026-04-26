defmodule Bludo.Repo.Migrations.AddControlBarVisibleToPresentationStates do
  use Ecto.Migration

  def change do
    alter table(:presentation_states) do
      add :control_bar_visible, :boolean, default: true
    end
  end
end
