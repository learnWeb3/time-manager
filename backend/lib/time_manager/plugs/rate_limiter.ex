defmodule TimeManager.Plugs.RateLimiter do
  alias TimeManager.Application

  def init(parameters \\ %{
    "scale_ms" => 1000,
    "limit" => 50
  }) do
    parameters
  end

  def call(%Plug.Conn{} = conn, parameters \\ %{
    "scale_ms" => 1000,
    "limit" => 50
  }) do
    try do
      token = auth_guard(conn)

      if is_nil(token) do
        raise JWTMissingTokenError
      else
        decoded = verify_token(token)
        user_id = Map.get(decoded, "sub", nil)
        current_user = Application.get_user!(user_id)

        # limit requests to 50 per second (1000 ms) per user (allowing multiple fetch as per current usage)
        user_id = current_user.id

        scale_ms = Map.get(parameters, "scale_ms", 1000)
        limit = Map.get(parameters, "limit", 50)
        case Hammer.check_rate(user_id, scale_ms, limit) do
          {:allow, _count} ->
            conn

          {:deny, limit} ->
            error = %{
              message:
                "request limit exceeded, too many requests, you are allowed up to #{limit} request per #{scale_ms}"
            }

            conn
            |> Plug.Conn.put_status(:too_many_requests)
            |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
        end
      end
    rescue
      e ->
        IO.inspect(e)
        error = %{message: Exception.message(e)}

        conn
        |> Plug.Conn.put_status(:unauthorized)
        |> Phoenix.Controller.render(TimeManagerWeb.ErrorView, "error.json", error: error)
    end
  end

  def call(_conn, _default) do
  end

  def auth_guard(conn) do
    extract_token(conn.req_headers)
  end

  def extract_token(headers) do
    authorization_header =
      Enum.find(headers, fn header ->
        [header_name, _header_value] = Elixir.Tuple.to_list(header)
        header_name == "authorization"
      end)

    if not is_nil(authorization_header) do
      [_header_name, header_value] = Elixir.Tuple.to_list(authorization_header)
      String.replace(header_value, "Bearer ", "", global: true)
    else
      nil
    end
  end

  def verify_token(token) do
    Application.verify_token(token)
  end
end
