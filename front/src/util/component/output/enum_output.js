import ApplicationOutput from './application_output'

export default class EnumOutput extends ApplicationOutput {
  defaultValue = (_) => this.props.attribute.enum.filter((e) => e.value === this.value())[0]?.title || this.value()
}
