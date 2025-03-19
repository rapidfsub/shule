alias EmilWeb.Form.CreateFormTest, as: ThisTest
use EmilWeb.TestPrelude

defmodule ThisTest.Survey do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept :*
      argument :questions, {:array, :map}, allow_nil?: false
      change manage_relationship(:questions, type: :create)
    end

    create :broken_create do
      accept :*
      argument :questions, {:array, :map}, allow_nil?: false

      change fn changeset, _ctx ->
        questions = Changeset.get_argument(changeset, :questions)
        Changeset.manage_relationship(changeset, :questions, questions, type: :create)
      end
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :title, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    has_many :questions, ThisTest.Question
  end
end

defmodule ThisTest.Question do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read, create: :*]
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :content, :ci_string, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :survey, ThisTest.Survey, allow_nil?: false
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "can create nested resources without builtin manage_relationship" do
    params = %{
      "title" => "survey",
      "questions" => %{
        "0" => %{"content" => "question 1"}
      }
    }

    survey = Form.for_create(ThisTest.Survey, :broken_create) |> Form.submit!(params: params)
    assert length(survey.questions) == 1
  end

  test "cannot add form without builtin manage_relationship" do
    assert_raise AshPhoenix.Form.NoFormConfigured, fn ->
      Form.for_create(ThisTest.Survey, :broken_create) |> Form.add_form(:questions)
    end
  end
end
