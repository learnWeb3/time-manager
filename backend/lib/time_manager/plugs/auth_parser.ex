defmodule JWTMissingTokenError do
  defexception message:
                 "Invalid or missing JWT token, you must be logged in to access this resource"
end

defmodule TimeManager.Plugs.Auth do
  def init(default), do: default

  def call(%Plug.Conn{} = conn, _default) do
    try do
      token = auth_guard(conn)

      if is_nil(token) do
        raise JWTMissingTokenError
      else
        Map.put(conn, :token, token)
      end
    rescue
      e ->
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
end
