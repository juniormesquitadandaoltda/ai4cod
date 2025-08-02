import ApplicationBase from '../../base/application_base'

export default class ApplicationFilter extends ApplicationBase {
  state = {
    blank: this.props.parent.filter()[this.props.attribute?.name] === '',
  }

  defaultValue = (suffix) => this.value(suffix)

  i18n = (path) =>
    this.I18n.t(this.props.parent.state.response.locale, `filter.${path}`, {
      attribute: this.title(),
    })

  title = (_) => this.props.attribute?.title || ''

  name = (suffix) => (suffix === 'is' ? this.props.attribute.name : `${this.props.attribute.name}_${suffix}`)

  error = (suffix) => (this.props.parent.state.response.error || {})[this.name(suffix)]

  onChange = (suffix) => {
    const value = this.parse(event)

    if (value === '')
      this.props.parent.setState((state) => {
        const filter = { ...state.filter }
        delete filter[this.name(suffix)]
        return { filter }
      })
    else this.props.parent.updateFilter({ [this.name(suffix)]: value })
  }

  onChangeBlank = (_) => {
    const checked = event.target.checked

    if (checked) {
      ;['in', 'gt', 'gte', 'lt', 'lte'].forEach((suffix) => {
        delete this.props.parent.state.filter[this.name(suffix)]
      })

      this.props.parent.state.filter[this.name('is')] = ''
    } else {
      delete this.props.parent.state.filter[this.name('is')]
    }

    this.props.parent.setState((state) => state)
    this.setState({ blank: checked })
  }

  value = (suffix) => this.props.parent.filter()[this.name(suffix)]

  mask = (_) =>
    this.I18n.t(this.props.parent.state.response.locale, `filter.mask.${this.props.attribute.type.toLowerCase()}`, {})

  parse = (event) => event.target.value

  isBlank = (_) => this.state.blank

  render = (_) => null
}
