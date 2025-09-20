defmodule Plato.Problem do
  use Ash.Resource,
    otp_app: :plato,
    domain: Plato.Domain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("problems")
    repo(Plato.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :content, :string do
      allow_nil?(false)
      constraints(min_length: 1, max_length: 1000)
    end

    attribute :subject, :atom do
      allow_nil?(false)
      constraints(one_of: [:math, :english])
    end

    attribute :difficulty, :atom do
      allow_nil?(false)
      constraints(one_of: [:low, :medium, :high])
    end

    attribute :option_a, :string do
      allow_nil?(false)
      constraints(max_length: 200)
    end

    attribute :option_b, :string do
      allow_nil?(false)
      constraints(max_length: 200)
    end

    attribute :option_c, :string do
      allow_nil?(false)
      constraints(max_length: 200)
    end

    attribute :option_d, :string do
      allow_nil?(false)
      constraints(max_length: 200)
    end

    attribute :correct_answer, :atom do
      allow_nil?(false)
      constraints(one_of: [:a, :b, :c, :d])
    end

    attribute :explanation, :string do
      constraints(max_length: 500)
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
      accept([
        :content,
        :subject,
        :difficulty,
        :option_a,
        :option_b,
        :option_c,
        :option_d,
        :correct_answer,
        :explanation,
        :campus_id
      ])
    end

    update :update do
      accept([
        :content,
        :subject,
        :difficulty,
        :option_a,
        :option_b,
        :option_c,
        :option_d,
        :correct_answer,
        :explanation,
        :campus_id
      ])
    end
  end
end
