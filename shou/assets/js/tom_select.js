import TomSelect from "tom-select"

export default {
  mounted() {
    const select = this.el.querySelector("select")
    this.tomSelect = new TomSelect(select, {})

    this.handleEvent(`${this.el.id}:settings`, (settings) => {
      if (this.tomSelect) {
        this.tomSelect.destroy()
      }
      this.tomSelect = new TomSelect(select, this.getSettings(settings))
    })
  },
  getSettings(settings) {
    const result = { ...settings }
    if (settings.valueField && settings.labelField && settings.searchField) {
      result.load = (query, callback) => {
        return new Promise((resolve, _reject) => {
          this.pushEventTo(this.el, "load", { query }, resolve)
        }).then(({ items }) => callback(items))
          .catch(_err => callback())
      }
    }
    return result
  }
}
