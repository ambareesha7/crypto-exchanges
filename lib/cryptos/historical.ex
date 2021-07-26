defmodule Cryptoc.Historical do
  @moduledoc """
  to keep historical data in memory
  """
  use GenServer
  alias Cryptos.{Exchanges, Product, Trade}

  @type t() :: %__MODULE__{
          products: [Product.t()],
          trades: %{Product.t() => Trade.t()}
        }
  defstruct [:products, :trades]

  def get_last_trade(pid \\ __MODULE__, product) do
    GenServer.call(pid, {:get_last_trade, product})
  end

  def get_last_trades(pid \\ __MODULE__, products) do
    GenServer.call(pid, {:get_last_trades, products})
  end

  def start_link(opts) do
    {prodicts, opts} = Keyword.pop(opts, :products, [])
    GenServer.start_link(__MODULE__, prodicts, opts)
  end

  def init(products) do
    historical = %__MODULE__{products: products, trades: %{}}
    {:ok, historical, {:continue, :subscribe}}
  end

  def handle_continue(:subscribe, historical) do
    Enum.each(historical.products, &Exchanges.subscriibe/1)
    {:noreply, historical}
  end

  def handle_info({:new_trade, trade}, historical) do
    updated_trades = Map.put(historical.trades, trade.product, trade)
    updated_historial = %{historical | trdaes: updated_trades}
    {:noreply, updated_historial}
  end

  def handle_call({:get_last_trade, product}, _from, historical) do
    trade = Map.get(historical.trade, product)
    {:reply, trade, historical}
  end

  def handle_call({:get_last_trades, products}, _from, historical) do
    trades = Enum.map(products, &Map.get(historical.trades, &1))
    {:reply, trades, historical}
  end
end
