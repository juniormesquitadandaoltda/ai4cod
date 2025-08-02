import ApplicationOutput from './application_output'

export default class DateOutput extends ApplicationOutput {
  defaultValue = (_) => {
    let value = this.value()

    if (!!value) {
      const d = value.split('-')
      value = `${d[2]}/${d[1]}/${d[0]}`
    }

    return value
  }
}
