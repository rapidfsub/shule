defmodule Tunez.Music.Artist do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "artists"
    repo Tunez.Repo

    custom_indexes do
      index "name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
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
      change Tunez.Music.Changes.UpdatePreviousNames, where: changing(:name)
    end

    destroy :destroy do
      primary? true
    end

    read :search do
      argument :query, :ci_string do
        constraints allow_empty?: true
        default ""
      end

      filter expr(contains(name, ^arg(:query)))
      pagination offset?: true, default_limit: 12
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :name, :string, allow_nil?: false, public?: true
    attribute :biography, :string
    attribute :previous_names, {:array, :string}, default: []
    timestamps public?: true
  end

  relationships do
    has_many :albums, Tunez.Music.Album, sort: [year_released: :desc]
  end

  aggregates do
    count :album_count, :albums, public?: true
    first :latest_album_year_released, :albums, :year_released, public?: true
    first :cover_image_url, :albums, :cover_image_url
  end

  json_api do
    type "artist"
  end
end
