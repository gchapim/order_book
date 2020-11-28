defmodule OrderBook.InstructionTest do
  use ExUnit.Case, async: true
  import ChangesetErrors

  alias OrderBook.Instruction

  @valid_attrs %{
    instruction: :new,
    side: :ask,
    price_level_index: 1,
    price: 80.0,
    quantity: 3
  }

  describe "changeset" do
    test "invalid instruction" do
      attrs = %{@valid_attrs | instruction: :invalid}

      assert %{instruction: ["is invalid"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "missing instruction" do
      attrs = %{@valid_attrs | instruction: nil}

      assert %{instruction: ["can't be blank"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "invalid side" do
      attrs = %{@valid_attrs | side: :invalid}

      assert %{side: ["is invalid"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "missing side" do
      attrs = %{@valid_attrs | side: nil}

      assert %{side: ["can't be blank"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "missing price_level_index" do
      attrs = %{@valid_attrs | price_level_index: nil}

      assert %{price_level_index: ["can't be blank"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "missing price" do
      attrs = %{@valid_attrs | price: nil}

      assert %{price: ["can't be blank"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "missing quantity" do
      attrs = %{@valid_attrs | quantity: nil}

      assert %{quantity: ["can't be blank"]} =
               %Instruction{} |> Instruction.changeset(attrs) |> errors_on()
    end

    test "valid attrs" do
      assert %Instruction{} |> Instruction.changeset(@valid_attrs) |> Map.get(:valid?)
    end
  end
end
