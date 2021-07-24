defmodule Cryptos do
  @moduledoc """
  Cryptos keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defdelegate available_products(), to: Cryptos.Exchanges
  defdelegate subscribe_to_trades(product), to: Cryptos.Exchanges, as: :subscribe
  defdelegate unsubscribe_from_trades(product), to: Cryptos.Exchanges, as: :unsubscribe
  defdelegate get_last_trade(product), to: Cryptos.Historical
end
