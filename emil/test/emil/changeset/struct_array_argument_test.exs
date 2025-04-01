use Emil.TestPrelude
alias Emil.Changeset.StructArrayArgumentTest, as: ThisTest

defmodule ThisTest.Survey do
  use Ash.Resource,
    data_layer: Ash.DataLayer.Ets,
    domain: TestDomain

  actions do
    defaults [:read]

    create :create do
      primary? true
      accept :*

      argument :questions, {:array, :struct} do
        allow_nil? false
        constraints min_length: 1, items: [instance_of: ThisTest.Question]
      end
    end

    create :strict_create do
      accept :*

      argument :questions, {:array, :struct} do
        allow_nil? false

        constraints min_length: 1,
                    items: [
                      instance_of: ThisTest.Question,
                      fields: [
                        content: [type: :string],
                        score: [type: :decimal]
                      ]
                    ]
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
    attribute :content, :string, allow_nil?: false, public?: true
    attribute :score, :decimal, allow_nil?: false, public?: true
  end

  relationships do
    belongs_to :survey, ThisTest.Survey, allow_nil?: false
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  @params %{
    "questions" => %{
      "0" => %{},
      "1" => %{content: "", invalid_key: nil},
      "2" => %{content: "question 3", score: "invalid value"}
    }
  }

  # ash v3.5.2에서 버그가 고쳐지면서 테스트 실패
  @tag :skip
  test "does not cast values without field type constraints" do
    changeset = Changeset.for_create(ThisTest.Survey, :create, @params)
    assert [q1, q2, q3] = Changeset.get_argument(changeset, :questions)

    assert q1.content == nil
    assert q2.content == ""
    refute Map.has_key?(q2, :invalid_key)
    assert q3.content == "question 3"
    assert q3.score == "invalid value"
  end

  test "raises an error if a field type constraint is violated" do
    assert_raise Ash.Error.Unknown, fn ->
      Changeset.for_create(ThisTest.Survey, :strict_create, @params)
    end
  end
end
