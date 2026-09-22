import { Controller } from "@hotwired/stimulus"

// Shows/hides panel targets depending on whether the source field's value
// is included in the comma-separated "show" value list.
export default class extends Controller {
  static targets = ["source", "panel"]
  static values = { show: Array }

  connect() {
    this.update()
  }

  update() {
    const visible = this.showValue.includes(this.currentValue())
    this.panelTargets.forEach((panel) => {
      panel.hidden = !visible
      panel.querySelectorAll("input, select, textarea").forEach((field) => {
        field.disabled = !visible && field.dataset.requiredWhenVisible === "true"
      })
    })
  }

  currentValue() {
    const el = this.sourceTarget
    if (el.type === "checkbox") return el.checked ? "true" : "false"
    return el.value
  }
}
