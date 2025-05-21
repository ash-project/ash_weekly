defmodule AshWeeklyWeb.PageController do
  use AshWeeklyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
