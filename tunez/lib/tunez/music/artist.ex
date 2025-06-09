defmodule Tunez.Music.Artist do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "artists"
    repo Tunez.Repo
  end

  actions do
    create :create do
      primary? true
      accept [:name, :biography]
    end

    read :read do
      primary? true
    end

    update :update do
      primary? true
      require_atomic? false
      accept [:name, :biography]

      change fn changeset, _context ->
        new_name = Ash.Changeset.get_attribute(changeset, :name)
        previous_name = Ash.Changeset.get_data(changeset, :name)
        previous_names = Ash.Changeset.get_data(changeset, :previous_names)

        names =
          [previous_name | previous_names]
          |> Enum.uniq()
          |> Enum.reject(fn name -> name == new_name end)

        Ash.Changeset.change_attribute(changeset, :previous_names, names)
      end do
        where changing(:name)
      end
    end

    destroy :destroy do
      primary? true
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :biography, :string
    attribute :previous_names, {:array, :string}, default: []
    timestamps []
  end

  relationships do
    has_many :albums, Tunez.Music.Album, sort: [year_released: :desc]
  end
end
