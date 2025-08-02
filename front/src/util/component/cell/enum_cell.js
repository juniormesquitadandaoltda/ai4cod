import ApplicationCell from './application_cell'

export default class EnumCell extends ApplicationCell {
  defaultValue = (_) => this.props.attribute.enum.filter((e) => e.value === this.value())[0]?.title
}
