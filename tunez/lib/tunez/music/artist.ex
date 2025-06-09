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
      accept [:name, :biography]
    end

    destroy :destroy do
      primary? true
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :biography, :string
    timestamps []
  end

  relationships do
    has_many :albums, Tunez.Music.Album, sort: [year_released: :desc]
  end
end
