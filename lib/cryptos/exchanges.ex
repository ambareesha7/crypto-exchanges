defmodule Cryptos.Exchanges do
  alias Cryptos.{Product, Trade}

  @cryptos_pubsub Application.get_env(:cryptos, CryptosWeb.Endpoint)
                  |> Keyword.fetch!(:pubsub_server)

  @clients [
    Cryptos.Exchanges.BitstampClient,
    Cryptos.Exchanges.CoinbaseClient
  ]
  @available_products (for client <- @clients, pair <- client.available_currency_pairs() do
                         Product.new(client.exchange_name(), pair)
                       end)

  @spec clients() :: [module()]
  def clients, do: @clients

  @spec available_products() :: [Product.t()]
  def available_products(), do: @available_products

  @spec subscribe(Product.t()) :: :ok | {:error, term()}
  def subscribe(product) do
    Phoenix.PubSub.subscribe(@cryptos_pubsub, topic(product))
  end

  @spec unsubscribe(Product.t()) :: :ok | {:error, term()}
  def unsubscribe(product) do
    Phoenix.PubSub.unsubscribe(@cryptos_pubsub, topic(product))
  end

  @spec broadcast(Trade.t()) :: :ok | {:error, term()}
  def broadcast(trade) do
    Phoenix.PubSub.broadcast(@cryptos_pubsub, topic(trade.product), {:new_trade, trade})
  end

  @spec topic(Product.t()) :: String.t()
  def topic(product) do
    to_string(product)
  end
end
