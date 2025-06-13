defmodule Tunez.Music.Artist do
  use Ash.Resource,
    otp_app: :tunez,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshJsonApi.Resource]

  postgres do
    table "artists"
    repo Tunez.Repo

    custom_indexes do
      index "name gin_trgm_ops", name: "artists_name_gin_index", using: "GIN"
    end
  end

  resource do
    description "A person or group of people that makes and releases music."
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
      description "List Artists, optionally filtering by name."

      argument :query, :ci_string do
        description "Return only artists with names including the given value."
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
    attribute :biography, :string, public?: true
    attribute :previous_names, {:array, :string}, default: [], public?: true
    timestamps public?: true
  end

  relationships do
    has_many :albums, Tunez.Music.Album, sort: [year_released: :desc], public?: true
  end

  aggregates do
    count :album_count, :albums, public?: true
    first :latest_album_year_released, :albums, :year_released, public?: true
    first :cover_image_url, :albums, :cover_image_url
  end

  json_api do
    type "artist"
    includes [:albums]
    derive_filter? false
  end

  graphql do
    type :artist

    filterable_fields [
      :album_count,
      :cover_image_url,
      :inserted_at,
      :latest_album_year_released,
      :updated_at
    ]
  end
end
