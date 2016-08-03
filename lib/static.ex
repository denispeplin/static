defmodule Static do
  use Application
  use Plug.Builder

  def start(_type, _args) do
    port = 8080

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, Static, [], port: port)
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  plug Plug.Logger
  plug Plug.Static,
    at: "/",
    from: "#{System.cwd()}/public"
  plug :not_found

  def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end
