import ApplicationOutput from './application_output'

export default class DecimalOutput extends ApplicationOutput {
  defaultValue = (_) => {
    const value = this.value()

    return !!value ? value.toString().replace('.', this.separator) : ''
  }

  separator = (_) => this.I18n.t(this.props.parent.state.response.locale, 'output.mask.decimal', {})
}
