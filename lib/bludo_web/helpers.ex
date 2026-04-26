defmodule BludoWeb.Helpers do
  use Gettext, backend: BludoWeb.Gettext

  def format_body(body) do
    url_regex = ~r/(https?:\/\/[^\s]+)/

    body
    |> String.split(url_regex, include_captures: true)
    |> Enum.map(fn
      "http" <> _rest = url ->
        escaped = url |> Phoenix.HTML.html_escape() |> Phoenix.HTML.safe_to_string()

        Phoenix.HTML.raw(
          ~s(<a href="#{escaped}" target="_blank" class="cursor-pointer text-primary-500 hover:underline font-medium">#{escaped}</a>)
        )

      text ->
        text
    end)
  end

  def body_without_links(text) do
    url_regex = ~r/(https?:\/\/[^\s]+)/
    String.replace(text, url_regex, "")
  end

  def format_date(nil), do: gettext("No date")

  def format_date(date) do
    Calendar.strftime(date, "%b %d, %Y")
  end

  def format_datetime(nil), do: gettext("No date")

  def format_datetime(dt) do
    Calendar.strftime(dt, "%Y-%m-%d %H:%M")
  end

  def interaction_responses_count(interaction) do
    case interaction do
      %Bludo.Polls.Poll{poll_opts: opts} when is_list(opts) ->
        Enum.sum(Enum.map(opts, &(&1.vote_count || 0)))

      %Bludo.Quizzes.Quiz{quiz_responses: responses} when is_list(responses) ->
        Enum.count(responses)

      %Bludo.Forms.Form{form_submits: submits} when is_list(submits) ->
        Enum.count(submits)

      _ ->
        0
    end
  end
end



