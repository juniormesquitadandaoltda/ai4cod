import ApplicationBase from '../../base/application_base'

export default class ApplicationInput extends ApplicationBase {
  defaultValue = (_) => this.value()

  i18n = (path) =>
    this.I18n.t(this.props.parent.state.response.locale, `input.${path}`, {
      attribute: this.title(),
    })

  title = (_) => this.props.attribute.title

  name = (_) => this.props.attribute.name

  error = (_) => (this.props.parent.state.response.error || {})[this.name()]

  onChange = (_) => {
    let value = this.parse(event)

    value = value === '' ? null : value

    this.props.parent.updateModel({ [this.name()]: value })
  }

  value = (_) => this.props.parent.model()[this.name()]

  mask = (_) =>
    this.I18n.t(this.props.parent.state.response.locale, `input.mask.${this.props.attribute.type.toLowerCase()}`, {})

  parse = (event) => event.target.value

  readOnly = (_) => !this.props.attribute.inputable

  render = (_) => null
}
