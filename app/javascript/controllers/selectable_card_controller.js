import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const cards = document.querySelectorAll(".selectable-card");
    const selectAllBtn = document.getElementById("select-all");
    let all_selected = false;

    selectAllBtn.addEventListener("click", function(event) {
      all_selected = !all_selected;
      cards.forEach((card) => {
        const checkbox = card.querySelector("input[type=checkbox]");
        checkbox.checked = all_selected;
        card.classList.toggle("selected", all_selected);

        // Optionally, add the 'selected' class to the parent here:
        // card.parentElement.classList.toggle("selected", all_selected);
      });

      if (all_selected) {
        selectAllBtn.textContent = "Deselect All";
      } else {
        selectAllBtn.textContent = "Select All";
      }
    });

    cards.forEach((card) => {
      const checkbox = card.querySelector("input[type=checkbox]");

      // Update the 'selected' class based on the initial checkbox state

      if (checkbox.checked) {
        card.parentElement.classList.add("selected");
      } else {
        card.parentElement.classList.remove("selected");
      }

      card.addEventListener("click", function(event) {
      console.log(card.parentElement);

        // Prevent the checkbox's default click behavior
        event.preventDefault();

        // Toggle the checkbox's checked state
        checkbox.checked = !checkbox.checked;

        // Toggle the 'selected' class on the card
        card.parentElement.classList.toggle("selected");

        // Optionally, add the 'selected' class to the parent here:
        // card.parentElement.classList.toggle("selected");
      });
    });
  }

  toggleCard(event) {
    event.preventDefault();

    const checkbox = event.currentTarget.querySelector("input[type=checkbox]");
    checkbox.checked = !checkbox.checked;
    event.currentTarget.parentElement.classList.toggle("selected");

    // Optionally, add the 'selected' class to the parent here:
    // event.currentTarget.parentElement.classList.toggle("selected");
  }

  disconnect() {
    // Clean up any resources or state specific to this controller
  }
}
