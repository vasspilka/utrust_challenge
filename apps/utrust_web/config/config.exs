# Since configuration is shared in umbrella projects, this file
# should only configure the :utrust_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :utrust_web,
  generators: [context_app: :utrust]

# Texas config
config :phoenix, :template_engines, texas: Texas.TemplateEngine
config :texas, pubsub: UtrustWeb.Endpoint
config :texas, router: UtrustWeb.Router

# Configures the endpoint
config :utrust_web, UtrustWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MKlDUsXdnoNEUFfn7pwSoJ9q+3F7Kp2QRuACAGFXi13lwlOHOxuPzHT9BMzDGF3p",
  render_errors: [view: UtrustWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: UtrustWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
