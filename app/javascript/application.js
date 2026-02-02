// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

document.addEventListener("turbo:load", () => {
    initAuthModal()
})

function initAuthModal() {
    const modal = document.getElementById("auth-modal");
    const openBtn = document.getElementById("open-auth-modal");
    const closeBtn = document.getElementById("close-auth-modal");

    const loginTab = document.getElementById("login-tab");
    const signupTab = document.getElementById("signup-tab");
    const loginForm = document.getElementById("login-form");
    const signupForm = document.getElementById("signup-form");

    if (!modal || !openBtn) return;

    // Open modal
    openBtn.addEventListener("click", () => {
        modal.classList.remove("hidden");
        modal.classList.add("flex");
    });

    // Close modal
    closeBtn.addEventListener("click", () => {
        modal.classList.add("hidden");
        modal.classList.remove("flex");
    });

    // Tabs
    loginTab.addEventListener("click", () => {
        loginForm.classList.remove("hidden");
        signupForm.classList.add("hidden");

        loginTab.classList.add("border-b-2", "border-blue-500", "font-bold");
        signupTab.classList.remove("border-b-2", "border-blue-500", "font-bold");
    });

    signupTab.addEventListener("click", () => {
        signupForm.classList.remove("hidden");
        loginForm.classList.add("hidden");

        signupTab.classList.add("border-b-2", "border-blue-500", "font-bold");
        loginTab.classList.remove("border-b-2", "border-blue-500", "font-bold");
    });
}

window.getTimeslot = function (date) {
  // Remove existing modal if open
  const existing = document.getElementById("timeslots-overlay")
  if (existing) existing.remove()

  const timeslotsCard = document.createElement("div")
  timeslotsCard.id = "timeslots-card"
  timeslotsCard.className =
    "border rounded-2xl p-5 shadow-xl max-w-md mx-auto max-h-[85vh] bg-white z-20 fixed inset-x-0 top-24 overflow-y-auto scrollbar-hide"

  timeslotsCard.innerHTML = `
    <div class="flex justify-between items-center mb-4">
      <h2 class="text-lg font-semibold text-heading">
        Available Timeslots
      </h2>
      <button id="removeTimeslotModal"
        class="text-neutral-400 hover:text-neutral-600 text-xl">
        &times;
      </button>
    </div>
    <p class="text-sm text-neutral-500 mb-4">${date}</p>
  `

  const modalOverlay = document.createElement("div")
  modalOverlay.id = "timeslots-overlay"
  modalOverlay.className = "fixed inset-0 flex items-start justify-center z-50"

  const modalBg = document.createElement("div")
  modalBg.className = "absolute inset-0 bg-black opacity-50 z-10"

  modalOverlay.appendChild(modalBg)
  modalOverlay.appendChild(timeslotsCard)
  document.body.appendChild(modalOverlay)

  const closeModal = () => modalOverlay.remove()

  document
    .getElementById("removeTimeslotModal")
    .addEventListener("click", closeModal)

  modalBg.addEventListener("click", closeModal)

  fetch(`/timeslots?date=${date}`)
    .then(res => res.json())
    .then(timeslots => {
      if (timeslots.length === 0) {
        timeslotsCard.innerHTML += `
          <p class="text-center text-neutral-500">
            No timeslots available for this date.
          </p>
        `
        return
      }

      timeslots.forEach(timeslot => {
        const availableTables = timeslot.tables.filter(
          t => t.status === "available"
        )

        const slot = document.createElement("div")
        slot.className =
          "border rounded-xl p-4 mb-3 hover:border-brand hover:bg-brand/5 transition"

        slot.innerHTML = `
          <div class="flex justify-between items-center mb-2">
            <span class="font-medium">
              ${timeslot.start_time} – ${timeslot.end_time}
            </span>
            <span class="text-xs text-neutral-500">
              ${availableTables.length} tables available
            </span>
          </div>

          <div class="flex flex-wrap gap-2">
            ${availableTables.map(table => `
              <button
                class="px-3 py-1 text-xs rounded-full border border-neutral-300
                       hover:border-brand hover:bg-black/10 transition cursor-pointer"
                onclick="selectTable(${table.timeslot_x_table_id})"
              >
                Table ${table.table_no} (${table.max_people}p)
              </button>
            `).join("")}
          </div>
        `

        timeslotsCard.appendChild(slot)
      })
    })
    .catch(() => {
      timeslotsCard.innerHTML += `
        <p class="text-center text-red-500">
          Failed to load timeslots.
        </p>
      `
    })
}

window.selectTable = function (timeslot_x_table_id) {
  window.location.href = `/home/reserve?timeslot_x_table_id=${timeslot_x_table_id}`;
}

