defmodule BludoWeb.UserView do
  use BludoWeb, :view

  def render("user.json", %{user: user}) do
    %{
      uuid: user.uuid,
      email: user.email
    }
  end
end



