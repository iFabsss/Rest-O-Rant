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
              ${formatTime12hr(timeslot.start_time)} – ${formatTime12hr(timeslot.end_time)}
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
    console.log("Selected TimeslotXTable ID:", timeslot_x_table_id);
    window.location.href = `/home/reserve?timeslot_x_table_id=${timeslot_x_table_id}`;
}

function formatTime12hr(time24) {
  const [hourStr, minute] = time24.split(":");
  let hour = parseInt(hourStr);
  const ampm = hour >= 12 ? "PM" : "AM";
  hour = hour % 12 || 12; // convert 0 => 12
  return `${hour}:${minute} ${ampm}`;
}


window.openReservationDetails = function(reservationId) {
  const existing = document.getElementById("reservation-details-overlay")
  if (existing) existing.remove()

  fetch(`/admin/reservations/${reservationId}.json`)
    .then(res => res.json())
    .then(data => {
      const modalOverlay = document.createElement("div")
      modalOverlay.id = "reservation-details-overlay"
      modalOverlay.className = "fixed inset-0 flex items-start justify-center z-50"

      const modalBg = document.createElement("div")
      modalBg.className = "absolute inset-0 bg-black/50 z-10"

      const modalContent = document.createElement("div")
      modalContent.className =
        "relative z-20 bg-white rounded-2xl shadow-xl w-full max-w-lg p-6 mt-20 border border-neutral-200"

        modalContent.innerHTML = `
        <form id="reservationEditForm" class="space-y-4">
            <div class="flex justify-between items-center mb-2">
            <h2 class="text-xl font-bold text-black">Reservation Details</h2>
            <button type="button" id="closeReservationDetails"
                class="text-neutral-400 hover:text-black text-2xl leading-none">
                &times;
            </button>
            </div>

            <div class="grid grid-cols-2 gap-3 text-sm">
            <div>
                <label class="text-gray-800">Date</label>
                <input type="text" value="${data.date}" disabled
                class="text-gray-800 w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>

            <div>
                <label class="text-gray-800">Time</label>
                <input type="text" value="${data.start_time} – ${data.end_time}" disabled
                class="text-gray-800 w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>

            <div>
                <label class="text-gray-800">Table</label>
                <input type="text" value="#${data.table_no} (Max ${data.max_people}p)" disabled
                class="text-gray-800 w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>

            <div>
                <label class="text-gray-800">People</label>
                <input name="people_num" type="number" value="${data.people_num}" disabled
                class="text-gray-800 editable w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>

            <div>
                <label class="text-gray-800">Contact Name</label>
                <input name="contact_name" type="text" value="${data.contact_name}" disabled
                class="text-gray-800 editable w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>

            <div>
                <label class="text-gray-800">Contact Email</label>
                <input name="contact_email" type="email" value="${data.contact_email}" disabled
                class="text-gray-800 editable w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>

            <div class="col-span-2">
                <label class="text-gray-800">Contact Number</label>
                <input name="contact_number" type="text" value="${data.contact_number}" disabled
                class="text-gray-800 editable w-full mt-1 bg-neutral-100 border border-neutral-300 rounded-lg px-3 py-2" />
            </div>
            </div>

            <div class="flex justify-end gap-2 pt-4">
            <button type="button" id="editReservationBtn"
                class="px-4 py-2 rounded-xl border border-blue-400 text-blue-600 hover:bg-blue-50 transition">
                Edit
            </button>

            <button type="submit" id="saveReservationBtn"
                class="hidden px-4 py-2 rounded-xl bg-blue-500 text-white hover:bg-blue-600 transition">
                Save
            </button>
            </div>
        </form>
        `
    
        const editBtn = modalContent.querySelector("#editReservationBtn")
        const saveBtn = modalContent.querySelector("#saveReservationBtn")
        const editableInputs = modalContent.querySelectorAll(".editable")

        editBtn.addEventListener("click", () => {
        editableInputs.forEach(input => {
            input.disabled = false
            input.classList.remove("bg-neutral-100")
            input.classList.add("bg-white")
        })

        editBtn.classList.add("hidden")
        saveBtn.classList.remove("hidden")
        })

        modalContent
        .querySelector("#reservationEditForm")
        .addEventListener("submit", e => {
            e.preventDefault()

            const formData = new FormData(e.target)

            fetch(`/admin/reservations/${reservationId}`, {
            method: "PATCH",
            body: formData,
            headers: {
                "X-CSRF-Token": document
                .querySelector("meta[name='csrf-token']")
                .content
            }
            }).then(() => location.reload())
        })


        modalOverlay.appendChild(modalBg)
        modalOverlay.appendChild(modalContent)
        document.body.appendChild(modalOverlay)

        const closeModal = () => modalOverlay.remove()

        modalBg.addEventListener("click", closeModal)
        document
            .getElementById("closeReservationDetails")
            .addEventListener("click", closeModal)
        })
        .catch(() => {
        alert("Failed to load reservation details.")
        })
}

window.openTimeslotDetails = function(id) {
  fetch(`/admin/timeslots/${id}`)
    .then(res => res.json())
    .then(data => {
      const overlay = document.createElement("div")
      overlay.className = "fixed inset-0 bg-black/50 flex items-center justify-center z-50"

      overlay.innerHTML = `
        <div class="bg-white p-6 rounded-xl w-[420px]">
            <h2 class="text-black text-xl font-bold mb-4">Timeslot</h2>

            <form id="timeslotForm">
            <input type="date" name="date" value="${data.date}" disabled
                class="text-gray-800 w-full mb-2 border p-2 rounded">

            <input type="time" name="start_time" value="${data.start_time}" disabled
                class="text-gray-800 w-full mb-2 border p-2 rounded">

            <input type="time" name="end_time" value="${data.end_time}" disabled
                class="text-gray-800 w-full mb-4 border p-2 rounded">

            <!-- TABLES SECTION -->
            <h3 class="text-black font-semibold mb-2">Assigned Tables</h3>

            <div id="tablesList" class="mb-4 space-y-2">
                ${data.tables.map(t => `
                <div class="text-gray-800 flex justify-between items-center border p-2 rounded">
                    <span>Table ${t.table_no} (${t.max_people} pax)</span>
                    <button
                    disabled
                    type="button"
                    class="text-red-500 text-sm"
                    onclick="removeTableFromTimeslot('${id}', '${t.id}')">
                    Remove
                    </button>
                </div>
                `).join("")}
            </div>

            <!-- ADD TABLE -->
            <div class="flex gap-2 mb-4">
                <select id="tableSelect" class="text-gray-800 border p-2 rounded w-full" disabled>
                <option class="text-gray-800" value="">Select table</option>
                ${data.available_tables.map(t => `
                    <option value="${t.id}">
                    Table ${t.table_no} (${t.max_people} pax)
                    </option>
                `).join("")}
                </select>

                <button
                disabled
                type="button"
                class="bg-green-500 text-white px-3 rounded"
                onclick="addTableToTimeslot('${id}')">
                Add
                </button>
            </div>

            <!-- ACTIONS -->
            <div class="flex justify-between">
                <button type="button" id="editBtn" class="text-blue-500">Edit</button>

                <button type="submit" id="saveBtn"
                class="hidden bg-blue-500 text-white px-4 py-2 rounded">
                Save
                </button>
            </div>
            </form>
        </div>
        `


      document.body.appendChild(overlay)

      const form = overlay.querySelector("#timeslotForm")
      const editBtn = overlay.querySelector("#editBtn")
      const saveBtn = overlay.querySelector("#saveBtn")

      editBtn.onclick = () => {
        form.querySelectorAll("input, button, select, option").forEach(i =>{
            i.disabled = false
            i.classList.add("hover:bg-gray-200", "rounded-lg")
        })
        saveBtn.classList.remove("hidden")
        editBtn.classList.add("hidden")
      }

      form.onsubmit = e => {
        e.preventDefault()
        const fd = new FormData(form)

        fetch(`/admin/timeslots/${id}`, {
          method: "PATCH",
          body: fd,
          headers: {
            "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
          }
        }).then(() => location.reload())
      }

      overlay.onclick = e => {
        if (e.target === overlay) overlay.remove()
      }
    })
}

window.openCreateTimeslot = function() {
  const overlay = document.createElement("div")
  overlay.className = "fixed inset-0 bg-black/50 flex items-center justify-center z-50"

  overlay.innerHTML = `
    <div class="bg-white p-6 rounded-xl w-96">
      <h2 class="text-xl font-bold text-black mb-4">New Timeslot</h2>

      <form id="createTimeslotForm">
        <input type="date" name="date" required class="text-gray-800 w-full mb-2 border p-2 rounded">
        <input type="time" name="start_time" required class="text-gray-800 w-full mb-2 border p-2 rounded">
        <input type="time" name="end_time" required class="text-gray-800 w-full mb-4 border p-2 rounded">
        <input type="number" name="max_no_tables" required min="1" placeholder="Max Number of Tables"
          class="text-gray-800 w-full mb-4 border p-2 rounded">

        <button class="w-full bg-green-500 text-white py-2 rounded">
          Create
        </button>
      </form>
    </div>
  `

  document.body.appendChild(overlay)

  overlay.querySelector("form").onsubmit = async e => {
    e.preventDefault()
    const fd = new FormData(e.target)
    
    // Convert FormData to JSON object
    const data = {
      timeslot: {
        date: fd.get('date'),
        start_time: fd.get('start_time'),
        end_time: fd.get('end_time'),
        max_no_tables: fd.get('max_no_tables')
      }
    }

    try {
      const response = await fetch("/admin/timeslots", {
        method: "POST",
        body: JSON.stringify(data),
        headers: {
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Content-Type": "application/json",
          "Accept": "application/json"
        }
      })
      
      if (response.ok) {
        location.reload()
      } else {
        const result = await response.json()
        alert('Error: ' + (result.errors || ['Unknown error']).join(', '))
      }
    } catch (error) {
      console.error('Error:', error)
      alert('Failed to create timeslot')
    }
  }

  overlay.onclick = e => {
    if (e.target === overlay) overlay.remove()
  }
}

window.deleteTimeslot = function(id) {
    console.log("Deleting timeslot with ID:", id);

  if (!confirm("Delete this timeslot?")) return

  fetch(`/admin/timeslots/${id}`, {
    method: "DELETE",
    headers: {
      "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
    }
  }).then(() => location.reload())
}

window.addTableToTimeslot = function(timeslotId) {
  const tableId = document.getElementById("tableSelect").value
  if (!tableId) return

  fetch(`/admin/timeslots/${timeslotId}/add_table`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
    },
    body: JSON.stringify({ table_id: tableId })
  }).then(() => location.reload())
}

window.removeTableFromTimeslot = function(timeslotId, tableId) {
  fetch(`/admin/timeslots/${timeslotId}/remove_table/${tableId}`, {
    method: "DELETE",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
    },
    body: JSON.stringify({ table_id: tableId })
  }).then(() => location.reload())
}
