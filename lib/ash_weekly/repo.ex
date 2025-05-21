defmodule AshWeekly.Repo do
  use Ecto.Repo,
    otp_app: :ash_weekly,
    adapter: Ecto.Adapters.Postgres
end
