defmodule TimeManager.Application.JwtToken do
  use Joken.Config

  def token_config do
    default_claims(default_exp: 60 * 60, aud: "time-manager", iss: "time-manager")
  end

end
