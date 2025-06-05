alias Emil.DynamicPreparationTest, as: ThisTest
use Emil.TestPrelude

defmodule ThisTest.FilterPositives do
  import Ash.Query, only: [filter: 2]
  use Ash.Resource.Preparation

  @impl Ash.Resource.Preparation
  def init(opts) do
    except = Keyword.get(opts, :except, [])
    {:ok, except: except}
  end

  @impl Ash.Resource.Preparation
  def prepare(query, opts, _context) do
    except = Keyword.fetch!(opts, :except)

    if query.action.name in except do
      query
    else
      filter(query, d1 > 0)
    end
  end
end

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: TestDomain,
    data_layer: Ash.DataLayer.Ets

  import Ash.Expr, only: [expr: 1]

  actions do
    defaults [:read, create: :*]

    read :list_negatives do
      filter expr(d1 < 0)
    end
  end

  preparations do
    prepare {ThisTest.FilterPositives, except: [:read, :list_negatives]}
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :d1, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "can skip preparations by action name" do
    for d1 <- -3..3 do
      Changeset.for_create(ThisTest.Obj, :create, %{d1: d1}) |> Ash.create!()
    end

    assert Ash.Query.for_read(ThisTest.Obj, :read) |> Ash.read!() |> length() == 7
    assert Ash.Query.for_read(ThisTest.Obj, :list_negatives) |> Ash.read!() |> length() == 3
  end
end
