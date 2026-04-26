defmodule BludoWeb.UserRegistrationView do
  import Phoenix.Component
  use BludoWeb, :view

  def render("user.json", %{user_registration: user}) do
    %{
      email: user.email,
      name: user.full_name
    }
  end
end



