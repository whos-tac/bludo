defmodule Bludo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []
    oidc_config = Application.get_env(:bludo, :oidc) || []
    Oban.Telemetry.attach_default_logger()

    children = [
      {Cluster.Supervisor, [topologies, [name: Bludo.ClusterSupervisor]]},
      # Start the Ecto repository
      Bludo.Repo,
      # Start the Telemetry supervisor
      BludoWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bludo.PubSub},
      # Start the rate limiter before the endpoint accepts requests
      Bludo.RateLimit,
      # Start the Endpoint (http/https)
      BludoWeb.Presence,
      BludoWeb.Endpoint,
      # Start a worker by calling: Bludo.Worker.start_link(arg)
      # {Bludo.Worker, arg}
      {Finch, name: Swoosh.Finch},
      {Task.Supervisor, name: Bludo.TaskSupervisor},
      {Oidcc.ProviderConfiguration.Worker,
       %{issuer: oidc_config[:issuer], name: Bludo.OidcProviderConfig}},
      {Oban, Application.fetch_env!(:bludo, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bludo.Supervisor]

    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BludoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end



