defmodule TimeManager.Plugs.Auth do
  alias TimeManager.Application

  def init(default), do: default

  def call(%Plug.Conn{} = conn, _default) do
    try do
      token = auth_guard(conn)

      if is_nil(token) do
        raise JWTMissingTokenError
      else
        decoded = verify_token(token)
        user_id = Map.get(decoded, "sub", nil)
        current_user = Application.get_user!(user_id)
        Map.put(conn, :current_user, current_user)
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

  def verify_token(token) do
    Application.verify_token(token)
  end
end
