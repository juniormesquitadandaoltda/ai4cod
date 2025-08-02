import ApplicationBase from '../../base/application_base'

export default class ApplicationCell extends ApplicationBase {
  defaultValue = (_) => this.value()

  i18n = (path) =>
    this.I18n.t(this.props.parent.state.response.locale, `cell.${path}`, {
      attribute: this.title(),
    })

  title = (_) => this.props.attribute.title

  name = (_) => this.props.attribute.name

  value = (_) => this.props.model[this.name()]

  render = (_) => (
    <td className='px-5 py-2.5 text-sm border-b dark:border-gray-700 whitespace-nowrap'>{this.defaultValue()}</td>
  )
}
