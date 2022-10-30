FROM elixir:alpine

RUN apk add --no-cache build-base make

COPY . /backend

# move to backend directory
WORKDIR /backend

ENV SECRET_KEY_BASE="Ro43oWcS99u/Zv+1YEYt/MNxx9prIlMOeyhIv2S0yn60hFdCPnY2/LOV34TuBg32"
ENV DATABASE_URL="ecto://postgres:postgres@postgres/time_manager"

# Initial setup
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile

# Compile assets
RUN MIX_ENV=prod mix assets.deploy

# Finally run the server
CMD MIX_ENV=prod mix ecto.migrate && MIX_ENV=prod mix run priv/repo/seeds.ex && PORT=4000 MIX_ENV=prod mix phx.server