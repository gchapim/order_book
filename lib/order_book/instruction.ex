defmodule OrderBook.Instruction do
  @moduledoc """
  Embedded schema model for an instruction.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @instruction_options [:new, :update, :delete]
  @side_options [:bid, :ask]

  @permitted_attrs [:instruction, :side, :price_level_index, :price, :quantity]

  embedded_schema do
    field(:instruction, Ecto.Enum, values: @instruction_options)
    field(:side, Ecto.Enum, values: @side_options)
    field(:price_level_index, :integer)
    field(:price, :float)
    field(:quantity, :integer)
  end

  def changeset(instruction, attrs \\ %{}) do
    instruction
    |> cast(attrs, @permitted_attrs)
    |> validate_required(@permitted_attrs)
  end

  def build(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action(:update)
  end
end
