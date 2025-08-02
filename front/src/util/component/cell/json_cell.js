import ApplicationCell from './application_cell'

export default class JSONCell extends ApplicationCell {
  defaultValue = (_) => {
    const value = this.value()

    return !!value ? JSON.stringify(value) : ''
  }
}
