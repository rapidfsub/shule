defmodule Plato.Campus do
  use Ash.Resource,
    otp_app: :plato,
    domain: Plato.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("campuses")
    repo(Plato.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      constraints(min_length: 1, max_length: 100)
    end

    attribute :address, :string do
      constraints(max_length: 255)
    end

    attribute :phone, :string do
      constraints(max_length: 20)
    end

    attribute :email, :string do
      constraints(max_length: 100)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  relationships do
    has_many :students, Plato.Student
    has_many :instructors, Plato.Instructor
    has_many :problems, Plato.Problem
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:name, :address, :phone, :email])
    end

    update :update do
      accept(:*)
    end
  end
end
