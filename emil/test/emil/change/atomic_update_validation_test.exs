alias Emil.Change.AtomicUpdateValidationTest, as: ThisTest

defmodule ThisTest.Obj do
  use Ash.Resource,
    domain: Emil.TestDomain,
    data_layer: Ash.DataLayer.Ets

  actions do
    defaults [:read, create: :*]

    update :add_atomic_balance do
      argument :offset, :decimal, allow_nil?: false
      change atomic_update(:balance, expr(balance + ^arg(:offset)))
      validate compare(:balance, greater_than_or_equal_to: 0)
    end

    update :add_balance do
      require_atomic? false

      argument :offset, :decimal, allow_nil?: false
      change atomic_update(:balance, expr(balance + ^arg(:offset)))

      validate fn changeset, _context ->
        balance = Ash.Changeset.get_attribute(changeset, :balance)

        if balance && Decimal.gte?(balance, 0) do
          :ok
        else
          {:error, "invalid"}
        end
      end
    end
  end

  attributes do
    uuid_v7_primary_key :id
    attribute :balance, :decimal, allow_nil?: false, public?: true
  end
end

defmodule ThisTest do
  use ExUnit.Case, async: true

  test "prevents atomic_update with atomic validation" do
    obj = Ash.Changeset.for_create(ThisTest.Obj, :create, %{balance: 100}) |> Ash.create!()
    assert to_string(obj.balance) == "100"

    changeset = Ash.Changeset.for_update(obj, :add_atomic_balance, %{offset: -10})
    obj = Ash.update!(changeset)
    assert to_string(obj.balance) == "90"

    changeset = Ash.Changeset.for_update(obj, :add_atomic_balance, %{offset: -100})
    assert {:error, _reason} = Ash.update(changeset)
  end

  test "does not prevent atomic_update with non atomic validation" do
    obj = Ash.Changeset.for_create(ThisTest.Obj, :create, %{balance: 100}) |> Ash.create!()
    assert to_string(obj.balance) == "100"

    changeset = Ash.Changeset.for_update(obj, :add_balance, %{offset: -10})
    obj = Ash.update!(changeset)
    assert to_string(obj.balance) == "90"

    changeset = Ash.Changeset.for_update(obj, :add_balance, %{offset: -100})
    obj = Ash.update!(changeset)
    assert to_string(obj.balance) == "-10"
  end
end
