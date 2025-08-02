import ApplicationCell from './application_cell'

export default class DecimalCell extends ApplicationCell {
  defaultValue = (_) => {
    const value = this.value()

    return !!value ? value.toString().replace('.', this.separator) : ''
  }

  separator = (_) => this.I18n.t(this.props.parent.state.response.locale, 'output.mask.decimal', {})
}
