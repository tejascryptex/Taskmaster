// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"


  document.addEventListener("turbo:load", function () {
    // Flash auto-hide
    const flash = document.getElementById("flash-message");
    if (flash) {
      setTimeout(() => {
        flash.style.transition = "opacity 0.5s";
        flash.style.opacity = 0;
        setTimeout(() => flash.remove(), 500);
      }, 1000);
    }
  });




