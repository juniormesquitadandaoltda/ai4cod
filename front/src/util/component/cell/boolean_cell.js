import ApplicationCell from './application_cell'

export default class BooleanCell extends ApplicationCell {
  defaultValue = (_) => (this.value() ? this.i18n('option.yes') : this.i18n('option.no'))
}
