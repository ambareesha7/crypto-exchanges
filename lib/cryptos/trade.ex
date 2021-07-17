defmodule Cryptos.Trade do
  alias Cryptos.Product

  @type t :: %__MODULE__{
          product: Product.t(),
          traded_at: DateTime.t(),
          price: String.t(),
          vollume: String.t()
        }
  defstruct [
    :product,
    :traded_at,
    :price,
    :vollume
  ]

  @spec new(Keyword.t()) :: t()
  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
