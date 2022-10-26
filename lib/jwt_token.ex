defmodule TimeManager.Application.JwtToken do
  use Joken.Config

  def token_config do
    default_claims(default_exp: 60 * 60, default_aud: "time-manager", default_iss: "time_manager")
  end

end
