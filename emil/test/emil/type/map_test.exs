defmodule Emil.Type.MapTest do
  use ExUnit.Case, async: true

  describe "apply_constraints" do
    test "returns ok with itself when no options are given" do
      assert {:ok, nil} = Ash.Type.Map.apply_constraints(nil, [])
      assert {:ok, "wow"} = Ash.Type.Map.apply_constraints("wow", [])
    end

    test "casts to an empty map when fields option is empty" do
      assert {:ok, %{}} = Ash.Type.Map.apply_constraints(nil, fields: [])
      assert {:ok, %{}} = Ash.Type.Map.apply_constraints("wow", fields: [])
    end

    test "omits keys not listed in fields option" do
      params = %{d1: "1", d2: "2"}
      assert {:ok, map} = Ash.Type.Map.apply_constraints(params, fields: [d1: [type: :decimal]])
      assert to_string(map.d1) == "1"
      refute Map.has_key?(map, :d2)
    end

    test "returns error when a field has an invalid type" do
      params = %{d1: "0.1a", d2: "0.2"}
      opts = [fields: [d1: [type: :decimal], d2: [type: :decimal]]]
      assert {:error, _reason} = Ash.Type.Map.apply_constraints(params, opts)
    end

    test "returns error when required fields are missing" do
      opts = [fields: [d1: [type: :decimal, allow_nil?: false]]]
      assert {:error, _reason} = Ash.Type.Map.apply_constraints(%{}, opts)
    end

    test "returns error when a field does not meet constraints" do
      opts = [fields: [d1: [type: :decimal, constraints: [min: 0]]]]
      assert {:error, _reason} = Ash.Type.Map.apply_constraints(%{d1: "-10"}, opts)
    end

    test "raises when nil is given but fields option exists" do
      assert_raise BadMapError, fn ->
        Ash.Type.Map.apply_constraints(nil, fields: [d1: [type: :decimal]])
      end
    end
  end
end
