defmodule BludoWeb.AttendeeRegistrationView do
  use BludoWeb, :view

  def render("attendee.json", %{attendee: attendee, token: token}) do
    %{
      name: attendee.name,
      avatar: attendee.avatar,
      token: token
    }
  end
end



