defmodule Tunez.Music.Album do
  use Ash.Resource, otp_app: :tunez, domain: Tunez.Music, data_layer: AshPostgres.DataLayer

  postgres do
    table "albums"
    repo Tunez.Repo
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end

    create :update do
      accept [:name, :year_released, :cover_image_url]
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false
    attribute :year_released, :integer, allow_nil?: false
    attribute :cover_image_url, :string
    timestamps []
  end

  relationships do
    belongs_to :artist, Tunez.Music.Artist, allow_nil?: false
  end
end
