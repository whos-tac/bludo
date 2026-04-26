defmodule BludoWeb.EventLive.ManagerComponents do
  use BludoWeb, :view_component
  use Gettext, backend: BludoWeb.Gettext
  use Phoenix.VerifiedRoutes, endpoint: BludoWeb.Endpoint, router: BludoWeb.Router, statics: BludoWeb.static_paths()

  alias Bludo.Presentations

  attr :event, :any, required: true
  attr :state, :any, required: true

  def slides_column(assigns) do
    ~H"""
    <div class="w-full h-full border-r border-gray-100 bg-gray-50 flex flex-col overflow-hidden">
      <div class="p-4 border-b border-gray-100 bg-white flex justify-between items-center shrink-0">
        <h2 class="font-bold text-gray-900">{gettext("Slides")}</h2>
        <span class="text-xs font-medium text-gray-400">{@state.position + 1} / {@event.presentation_file.length}</span>
      </div>
      <div id="slides-layout" class="flex-1 overflow-y-auto p-4 space-y-4 scroll-smooth">
        <%= if @event.presentation_file.length == 0 do %>
          <div class="h-full flex flex-col items-center justify-center text-center p-6 space-y-4">
            <div class="w-16 h-16 bg-gray-100 rounded-2xl flex items-center justify-center text-gray-400">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
            </div>
            <div>
              <p class="text-sm font-bold text-gray-900">{gettext("No slides yet")}</p>
              <p class="text-xs text-gray-500 mt-1">{gettext("Upload a PDF")}</p>
            </div>
            <a href={~p"/e/#{@event.code}/manage/add/presentation"} phx-click={JS.patch(~p"/e/#{@event.code}/manage/add/presentation")} class="inline-flex items-center px-4 py-2 bg-primary-500 hover:bg-primary-600 text-white text-xs font-bold rounded-lg transition-colors">
              {gettext("Upload")}
            </a>
          </div>
        <% else %>
          <%= for {url, index} <- Enum.with_index(Presentations.get_slide_urls(@event.presentation_file)) do %>
            <div
              id={"slide-preview-#{index}"}
              phx-click="current-page"
              phx-value-page={index}
              class={"relative aspect-video rounded-xl overflow-hidden cursor-pointer border-2 transition-all duration-200 group #{if @state.position == index, do: "border-primary-500 ring-4 ring-primary-50/50 shadow-lg", else: "border-transparent hover:border-gray-300 shadow-sm"}"}
            >
              <img src={url} class="w-full h-full object-cover" />
              <div class="absolute bottom-2 left-2 px-1.5 py-0.5 bg-black/50 backdrop-blur-md rounded text-[10px] text-white font-bold">
                {index + 1}
              </div>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  attr :interactions, :list, required: true
  attr :event, :any, required: true

  def interactions_sidebar(assigns) do
    ~H"""
    <div class="h-full flex flex-col overflow-hidden bg-gray-50/30">
      <div class="p-6 border-b border-gray-100 flex items-center justify-between shrink-0 bg-white">
         <h3 class="text-sm font-black uppercase tracking-widest text-gray-900">{gettext("Interactions")}</h3>
         <button phx-click="toggle-interaction-modal" class="bg-primary-500 hover:bg-primary-600 text-white p-2 rounded-lg transition-colors shadow-sm">
           <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4" /></svg>
         </button>
      </div>
      
      <div class="flex-1 p-6 space-y-4 overflow-y-auto pr-2">
        <%= if length(@interactions) == 0 do %>
           <p class="text-xs text-gray-400 italic text-center py-8">{gettext("No interactions for this slide")}</p>
        <% end %>
        <%= for interaction <- @interactions do %>
          <div class={"p-4 rounded-xl border-2 transition-all #{if interaction.enabled, do: "border-primary-500 bg-primary-50/30 shadow-md", else: "border-gray-50 bg-white shadow-sm"}"}>
            <div class="flex justify-between items-center mb-3">
              <span class="px-2 py-0.5 bg-gray-100 rounded text-[9px] font-black uppercase text-gray-400">{interaction_type(interaction)}</span>
              <button phx-click={if interaction.enabled, do: "interaction-disable", else: "interaction-enable"} phx-value-id={interaction.id} phx-value-type={interaction_type(interaction)} class={"text-[10px] font-black uppercase px-3 py-1.5 rounded-md shadow-sm transition-all #{if interaction.enabled, do: "bg-supporting-red-500 text-white", else: "bg-primary-500 text-white hover:bg-primary-600"}"}>
                {if interaction.enabled, do: gettext("Stop"), else: gettext("Start")}
              </button>
            </div>
            <p class="text-sm font-bold text-gray-900 leading-tight">
               <a href={edit_path(@event.code, interaction)} class="hover:text-primary-600 transition-colors">{interaction.title}</a>
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  attr :list_tab, :atom, required: true
  attr :post_count, :integer, required: true
  attr :pinned_post_count, :integer, required: true
  attr :streams, :any, required: true
  attr :event, :any, required: true

  def qa_sidebar(assigns) do
    ~H"""
    <div class="h-full flex flex-col overflow-hidden bg-white">
      <div class="p-6 border-b border-gray-100 flex items-center justify-between shrink-0 bg-white">
        <h3 class="text-sm font-black uppercase tracking-widest text-gray-900">{gettext("Audience Q&A")}</h3>
        <div class="flex items-center space-x-1 bg-gray-100 p-1 rounded-xl">
          <button phx-click="list-tab" phx-value-tab="posts" class={"px-3 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider transition-all #{if @list_tab == :posts, do: "bg-white text-gray-900 shadow-sm", else: "text-gray-400 hover:text-gray-600"}"}>{gettext("Live")}</button>
          <button phx-click="list-tab" phx-value-tab="pinned_posts" class={"px-3 py-1.5 rounded-lg text-[10px] font-black uppercase tracking-wider transition-all #{if @list_tab == :pinned_posts, do: "bg-white text-gray-900 shadow-sm", else: "text-gray-400 hover:text-gray-600"}"}>{gettext("Pinned")}</button>
        </div>
      </div>
      
      <div class="flex-1 overflow-y-auto p-6 space-y-4">
        <%= if @list_tab == :posts do %>
          <div :if={@post_count == 0} class="h-full flex flex-col items-center justify-center text-center opacity-30 py-12">
            <svg class="w-12 h-12 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" /></svg>
            <p class="text-sm font-bold">{gettext("No questions yet")}</p>
          </div>
          <div id="post-list" phx-update="stream" class="space-y-4">
            <.live_component :for={{id, post} <- @streams.posts} module={BludoWeb.EventLive.ManageablePostComponent} id={id} event={@event} post={post} />
          </div>
        <% end %>
        <%= if @list_tab == :pinned_posts do %>
          <div :if={@pinned_post_count == 0} class="h-full flex flex-col items-center justify-center text-center opacity-30 py-12">
            <svg class="w-12 h-12 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" /></svg>
            <p class="text-sm font-bold">{gettext("No pinned questions")}</p>
          </div>
          <div id="pinned-post-list" phx-update="stream" class="space-y-4">
            <.live_component :for={{id, post} <- @streams.pinned_posts} module={BludoWeb.EventLive.ManageablePostComponent} id={id} event={@event} post={post} />
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  attr :create, :any, required: true
  attr :state, :any, required: true
  attr :current_interaction, :any, required: true

  def settings_sidebar(assigns) do
    ~H"""
    <div class="h-full flex flex-col overflow-hidden bg-gray-50/50">
      <div class="p-6 border-b border-gray-100 bg-white shrink-0">
        <h3 class="text-[10px] font-black uppercase tracking-widest text-gray-400">{gettext("Quick Settings")}</h3>
      </div>
      <div class="flex-1 overflow-y-auto p-6">
        <.live_component id="settings-pane" module={BludoWeb.EventLive.ManagerSettingsComponent} create={@create} state={@state} current_interaction={@current_interaction} />
      </div>
    </div>
    """
  end

  defp interaction_type(%Bludo.Polls.Poll{}), do: "poll"
  defp interaction_type(%Bludo.Forms.Form{}), do: "form"
  defp interaction_type(%Bludo.Quizzes.Quiz{}), do: "quiz"
  defp interaction_type(%Bludo.Embeds.Embed{}), do: "embed"
  defp interaction_type(_), do: "unknown"

  defp edit_path(code, interaction) do
    case interaction do
      %Bludo.Polls.Poll{} -> ~p"/e/#{code}/manage/edit/poll/#{interaction.id}"
      %Bludo.Quizzes.Quiz{} -> ~p"/e/#{code}/manage/edit/quiz/#{interaction.id}"
      %Bludo.Forms.Form{} -> ~p"/e/#{code}/manage/edit/form/#{interaction.id}"
      _ -> "#"
    end
  end
end
