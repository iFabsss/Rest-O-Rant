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