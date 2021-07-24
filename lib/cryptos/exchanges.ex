defmodule Cryptos.Exchanges do
  alias Cryptos.{Product, Trade}

  @spec subscriibe(Product.t()) :: :ok | {:error, term()}
  def subscriibe(product) do
    Phoenix.PubSub.subscribe(Cryptos.PubSub, topic(product))
  end

  @spec unsubscribe(Product.t()) :: :ok | {:error, term()}
  def unsubscribe(product) do
    Phoenix.PubSub.unsubscribe(Cryptos.PubSub, topic(product))
  end

  @spec broadcast(Trade.t()) :: :ok | {:error, term()}
  def broadcast(trade) do
    Phoenix.PubSub.broadcast(Cryptos.PubSub, topic(trade.product), {:new_trade, trade})
  end

  @spec topic(Product.t()) :: String.t()
  def topic(product) do
    to_string(product)
  end
end
