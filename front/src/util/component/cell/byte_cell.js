import ApplicationCell from './application_cell'

export default class ByteCell extends ApplicationCell {
  defaultValue = (_) => {
    const bytes = this.value()

    if (bytes === 0) return '0 Bytes'

    const k = 1000
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))

    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }
}
