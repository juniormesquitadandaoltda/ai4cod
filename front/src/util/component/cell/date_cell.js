import ApplicationCell from './application_cell'

export default class DateCell extends ApplicationCell {
  defaultValue = (_) => {
    let value = this.value()

    if (!!value) {
      const d = value.split('-')
      value = `${d[2]}/${d[1]}/${d[0]}`
    }

    return value
  }
}
