FROM elixir:alpine

RUN apk add --no-cache build-base make

COPY . /backend

# move to backend directory
WORKDIR /backend

# Initial setup
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile

# Compile assets
RUN MIX_ENV=prod DATABASE_URL=${DATABASE_URL} SECRET_KEY_BASE=${SECRET_KEY_BASE} mix assets.deploy

# Finally run the server
CMD MIX_ENV=prod mix ecto.migrate && MIX_ENV=prod && PORT=4000 MIX_ENV=prod mix phx.server