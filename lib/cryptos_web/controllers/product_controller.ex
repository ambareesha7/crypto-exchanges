defmodule CryptosWeb.ProductController do
  use CryptosWeb, :controller

  def index(conn, _params) do
    trades =
      Cryptos.available_products()
      |> Cryptos.get_last_trades()

    render(conn, "index.html", trades: trades)
  end
end
