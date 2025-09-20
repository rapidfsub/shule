defmodule Plato.Instructor do
  use Ash.Resource,
    otp_app: :plato,
    domain: Plato.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("instructors")
    repo(Plato.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      constraints(min_length: 1, max_length: 100)
    end

    attribute :email, :string do
      constraints(max_length: 100)
    end

    attribute :phone, :string do
      constraints(max_length: 20)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  relationships do
    belongs_to :campus, Plato.Campus do
      allow_nil?(false)
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:name, :email, :phone, :campus_id])
    end

    update :update do
      accept([:name, :email, :phone, :campus_id])
    end
  end
end
