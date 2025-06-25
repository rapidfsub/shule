import TomSelect from "tom-select"

export default {
  mounted() {
    const select = this.el.querySelector("select")
    this.tomSelect = new TomSelect(select, {});
  }
}
