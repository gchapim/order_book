defmodule OrderBook.Instruction do
  @moduledoc """
  Embedded schema model for an instruction.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @instruction_options [:new, :update, :delete]
  @side_options [:bid, :ask]

  @permitted_attrs [:instruction, :side, :price_level_index, :price, :quantity]

  @type t :: %__MODULE__{
          instruction: atom(),
          side: atom(),
          price_level_index: number(),
          price: float(),
          quantity: number()
        }

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
    |> validate()
  end

  defp validate(%Ecto.Changeset{changes: %{instruction: :delete}} = changeset) do
    changeset
    |> validate_required([:price_level_index, :side])
  end

  defp validate(changeset) do
    changeset
    |> validate_required(@permitted_attrs)
  end

  def build(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> apply_action(:update)
  end
end
