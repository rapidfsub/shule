defmodule Tunez.Music.Album do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "albums"
    repo Tunez.Repo

    references do
      reference :artist, index?: true, on_delete: :delete
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:name, :year_released, :cover_image_url, :artist_id]
    end

    update :update do
      accept [:name, :year_released, :cover_image_url]
    end
  end

  validations do
    validate compare(:year_released,
               greater_than: 1950,
               less_than_or_equal_to: &__MODULE__.next_year/0
             ) do
      where present(:year_released)
      message "must be between 1950 and next year"
    end

    validate match(:cover_image_url, ~S[^(https://|/images/).+(\.png|\.jpg)$]) do
      where changing(:cover_image_url)
      message "must start with https:// or /images/"
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

  identities do
    identity :unique_album_names_per_artist, [:name, :artist_id] do
      message "already exists for this artist"
    end
  end

  def next_year() do
    Date.utc_today().year + 1
  end

  json_api do
    type "album"
  end
end
