defmodule TimeManager.Application.Role do
  def get do
    %{"admin" => 1, "manager" => 2, "employee" => 3}
  end
end
