defmodule BludoWeb.EventLive.FormSubmissionComponent do
  use BludoWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={@id} class="bg-white rounded-xl border border-gray-100 shadow-sm overflow-hidden hover:shadow-md transition-shadow">
      <div class="p-4 border-b border-gray-50 bg-gray-50/50 flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <div class="relative">
            <img
              class="h-8 w-8 rounded-full bg-gray-200"
              src={"https://api.dicebear.com/7.x/personas/svg?seed=#{@submission.attendee_identifier || @submission.user_id}"}
              alt="avatar"
            />
          </div>
          <div>
            <p class="text-sm font-bold text-gray-900">
              {@submission.attendee_identifier || (if @submission.user, do: @submission.user.email, else: "User ##{@submission.user_id}")}
            </p>
            <p class="text-[10px] text-gray-400 uppercase tracking-tighter font-semibold">
              {format_datetime(@submission.inserted_at)}
            </p>
          </div>
        </div>
        <div class="flex space-x-1">
          <button
            phx-click="delete-submission"
            phx-value-id={@submission.id}
            data-confirm={gettext("Are you sure you want to delete this submission?")}
            class="p-1.5 text-gray-400 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
          >
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
          </button>
        </div>
      </div>
      
      <div class="p-4 space-y-4">
        <div class="grid grid-cols-1 gap-4">
          <%= for {key, value} <- @submission.response do %>
            <div class="group">
              <p class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-1 group-hover:text-primary-500 transition-colors">{key}</p>
              <p class="text-gray-900 font-medium bg-gray-50 rounded-lg px-3 py-2 border border-gray-100">{value}</p>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
