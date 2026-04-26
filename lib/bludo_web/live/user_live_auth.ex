defmodule BludoWeb.UserLiveAuth do
  import Phoenix.LiveView
  import Phoenix.Component

  use Phoenix.VerifiedRoutes,
    endpoint: BludoWeb.Endpoint,
    router: BludoWeb.Router

  def on_mount(:default, _params, session, socket) do
    user = 
      case session do
        %{"current_user" => user} when not is_nil(user) -> user
        %{"user_token" => token} when not is_nil(token) -> Bludo.Accounts.get_user_by_session_token(token)
        _ -> nil
      end

    if user do
      socket = assign_new(socket, :current_user, fn -> user end)

      cond do
        not Application.get_env(:bludo, :email_confirmation) ->
          {:cont, socket}

        user.confirmed_at ->
          {:cont, socket}

        true ->
          {:halt, redirect(socket, to: ~p"/users/register/confirm")}
      end
    else
      {:halt, redirect(socket, to: ~p"/users/log_in")}
    end
  end
end



