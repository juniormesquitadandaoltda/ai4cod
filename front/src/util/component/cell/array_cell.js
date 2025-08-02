import ApplicationCell from './application_cell'

export default class ArrayCell extends ApplicationCell {
  defaultValue = (_) => {
    const value = this.value()

    return !!value ? value.join(',') : ''
  }
}
