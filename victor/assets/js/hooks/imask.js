import IMask from "imask"

export default {
  mounted() {
    this.input = this.el.querySelector(`input[type="text"]`)
    this.hiddenInput = this.el.querySelector(`input[type="hidden"]`)
    this.mask = IMask(this.input, this.getOptions())

    for (const type of ["input", "change"]) {
      this.input.addEventListener(type, (e) => {
        e.stopPropagation()
        this.hiddenInput.value = this.mask.unmaskedValue
        this.hiddenInput.dispatchEvent(new Event(type, { bubbles: true }))
      })
    }

    this.updateFromServer()
  },
  updated() {
    this.updateFromServer()
  },
  destroyed() {
    this.mask.destroy()
  },
  reconnected() {
    this.updateFromServer()
  },
  getOptions() {
    const options = {
      ...this.el.dataset,
    }
    if (options.mask) {
      options.mask = window[options.mask]
    }
    return options
  },
  updateFromServer() {
    this.mask.unmaskedValue = this.hiddenInput.value
  }
}
