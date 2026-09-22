import { Controller } from "@hotwired/stimulus"

// On the sale form: warns when the selected phone has iCloud pending release,
// and suggests its listed sale price if the price field is still empty.
export default class extends Controller {
  static targets = ["select", "warning", "salePrice"]
  static values = { pending: Array, prices: Object }

  connect() {
    this.update()
  }

  update() {
    const pendingIds = this.pendingValue.map(String)
    const selected = this.selectTarget.value
    this.warningTarget.hidden = !pendingIds.includes(selected)

    if (this.hasSalePriceTarget && !this.salePriceTarget.value) {
      const suggested = this.pricesValue[selected]
      if (suggested) this.salePriceTarget.value = suggested
    }
  }
}
