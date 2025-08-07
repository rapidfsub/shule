import TomSelect from "tom-select"

export default {
  mounted() {
    const select = this.el.querySelector("select")
    this.tomSelect = new TomSelect(select, {})

    this.handleEvent(`${this.el.id}:settings`, (payload) => {
      if (this.tomSelect) {
        this.tomSelect.destroy()
      }
      this.tomSelect = new TomSelect(select, this.getSettings(payload))
    })
  },
  getSettings({ settings, isRemote }) {
    if (isRemote) {
      const fetch = (query, keyset) => {
        return new Promise((resolve, _reject) => {
          this.pushEventTo(this.el, "load", { query, keyset }, resolve)
        })
      }

      return {
        ...settings,
        firstUrl: (_query) => null,
        load: function (query, callback) {
          const keyset = this.getUrl(query);
          fetch(query, keyset)
            .then(({ items, after, keyset }) => {
              // https://github.com/orchidjs/tom-select/issues/556#issuecomment-1919066054
              const _scrollToOption = this.scrollToOption
              this.scrollToOption = () => { }
              if (after) {
                this.setNextUrl(query, keyset)
              }
              callback(items)
              this.scrollToOption = _scrollToOption
            })
            .catch(_err => callback())
        }
      }
    }
    return settings
  }
}
