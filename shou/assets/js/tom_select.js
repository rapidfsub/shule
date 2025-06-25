import TomSelect from "tom-select"

export default {
  mounted() {
    const select = this.el.querySelector("select")
    const settings = this.getSettings()
    this.tomSelect = new TomSelect(select, settings);
  },
  getSettings() {
    const keys = ["create", "createOnBlur", "persist"]
    const result = {}
    for (const [key, value] of Object.entries(this.el.dataset)) {
      if (keys.includes(key)) {
        if (value === "true") {
          result[key] = true
        } else if (value === "false") {
          result[key] = false
        } else {
          result[key] = value
        }
      }
    }
    return result
  }
}
