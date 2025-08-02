import ApplicationCell from './application_cell'

export default class DateTimeCell extends ApplicationCell {
  defaultValue = (_) => {
    let value = this.value()

    if (!!value) {
      const d = value
        .replace(/[\s:-]/g, '_')
        .replace('__', '_-')
        .split('_')
      value = `${d[2]}/${d[1]}/${d[0]} ${d[3]}:${d[4]}:${d[5]}`
    }

    return value
  }
}
