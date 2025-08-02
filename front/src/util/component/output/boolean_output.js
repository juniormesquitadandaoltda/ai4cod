import ApplicationOutput from './application_output'

export default class BooleanOutput extends ApplicationOutput {
  defaultValue = (_) => (this.value() ? this.i18n('option.yes') : this.i18n('option.no'))
}
