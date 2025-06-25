import TomSelect from "tom-select"

export default {
  mounted() {
    const select = this.el.querySelector("select")
    this.tomSelect = new TomSelect(select, {})

    this.handleEvent(`${this.el.id}:settings`, (settings) => {
      if (this.tomSelect) {
        this.tomSelect.destroy()
      }
      this.tomSelect = new TomSelect(select, settings)
    })
  },
}
