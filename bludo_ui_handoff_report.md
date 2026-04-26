# Bludo UI Redesign & Bug Fix Handoff Report

## 1. Current Status & Context
We are in the process of redesigning the Bludo application (a real-time audience interaction tool similar to Slido) to feature a modern, minimalist aesthetic. The focus has been on the Manager Dashboard (`manage.html.heex`) and the Audience View (`show.html.heex`). 

During the aggressive UI overhaul, numerous core Elixir/LiveView event handlers and HTML IDs were inadvertently stripped, causing the application to "freeze" or fail to reflect real-time state changes without a page reload. We have spent the last few turns restoring this underlying plumbing while maintaining the new 3-column minimalist layout for the manager dashboard. 

The workflow was paused just before the final browser-based end-to-end verification could be completed.

## 2. What Has Been Fixed Recently
* **Restored LiveView Handlers (`manage.ex`)**: Re-added missing `handle_event` and `handle_info` clauses for critical interactions, including:
  * `checked` (for Quick Settings toggles)
  * `interaction-enable` / `interaction-disable` (for Activating/Stopping Polls, Quizzes, Forms)
  * `toggle-chat`, `pin-post`, `unpin-post`, `delete-post`, `ban-user`
* **Fixed UI Toggle Animations (`input_component.ex`)**: Added dynamic IDs (`id={"check-#{@key}"}`) to the toggle switches. Previously, `Phoenix.LiveView.JS` was failing to apply transition classes because it couldn't find the target buttons in the DOM.
* **Vertical Slide Scrolling (`manager.js`)**: Updated the `Manager` JS hook. Since the new slide layout is a vertical column (rather than horizontal), the hook was updated to use `scrollTop` and `clientHeight` to keep the active slide in view automatically.
* **Presenter/Audience Animations (`presenter.js`)**: Updated the `chat-visible` handler to target the new `#post-list-wrapper` ID for smooth slide-in animations, and added a defensive check to prevent `tiny-slider` from initializing multiple times and crashing on LiveView updates.
* **Modal Reliability (`manage.html.heex`)**: Ensured modal close buttons have `type="button"` to prevent accidental form submissions, and verified z-indexes so the backdrop doesn't obscure the close button.

## 3. Incomplete Tasks & Immediate Next Steps
The next agent or developer picking this up should immediately verify the following flows in the browser:

1. **Interaction Lifecycle**:
   * Open the "Add Interaction" modal and create a new Poll.
   * Verify the Poll form submits correctly and the new Poll appears in the middle column.
   * Click "Activate" on the Poll and verify it turns green ("Live") and the button changes to "Stop".
2. **Audience Synchronization**:
   * Have a host window (`/e/:code/manage`) and an audience window (`/e/:code`) open side-by-side.
   * Verify that when the host activates a poll, it instantly appears on the audience screen.
   * Verify that when the host toggles "Show Q&A" in the quick settings, the audience view updates accordingly.
3. **Slide Navigation**:
   * Click a slide in the left-hand column and ensure the central Preview iframe updates to the selected slide.

## 4. Known Issues & Potential Bugs to Investigate
* **404 on "Add Presentation"**: The current browser state shows a 404 error at `http://localhost:4000/e/test123456/manage/add/presentation`. This implies the routing or the link for uploading presentation slides is broken or pointing to the wrong endpoint. The `router.ex` and the "upload" button links need to be verified.
* **Empty Slides Column UI**: If no presentation file is attached to an event, the slides column is currently completely empty. We need an "empty state" UI here (e.g., an "Upload Presentation" button) so the manager intuitively knows how to add slides.
* **Audience View Slide Visibility**: Currently, `show.html.heex` (the audience view) focuses heavily on the interactions (polls/Q&A) and does not embed an iframe of the actual presentation slides. If the intention was for the audience to also see the slides on their mobile devices, an iframe or image viewer needs to be added back to `show.html.heex`.
* **JS Hook Mounting Issues**: If LiveView morphs the DOM heavily, elements with `phx-hook` (like `#manager` or `#presenter`) might re-trigger their `mounted()` or `updated()` callbacks. Ensure the JavaScript is idempotent (e.g. doesn't duplicate event listeners or slider instances).

## 5. Future Redesign & Architecture Considerations
* **Component Extraction**: `manage.html.heex` and `show.html.heex` are extremely large. The UI blocks (e.g., the Slides Column, the Quick Settings Sidebar, the Active Poll display) should be broken out into separate Phoenix functional components (e.g., `BludoWeb.ManagerComponents.slides_column/1`) to improve readability and maintainability.
* **Responsive Design**: The new 3-column manager layout looks great on a large desktop, but will be unusable on an iPad or smaller screen. Implement a responsive strategy (e.g., hiding the slides column on smaller screens behind a toggle menu) using Tailwind's `md:` and `lg:` breakpoints.
* **Consolidated Settings**: Right now, there are settings in a "Settings Pane" modal, and "Quick Settings" in the sidebar. These should be conceptually unified to prevent user confusion.
* **Dynamic Theming**: To truly mimic Slido's clean, brandable aesthetic, ensure primary colors (`bg-primary-500`, etc.) are mapped to CSS variables in `app.css` so different events can dynamically apply different brand colors.
