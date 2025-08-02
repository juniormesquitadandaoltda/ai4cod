import ApplicationBase from '../../base/application_base'

export default class ApplicationOutput extends ApplicationBase {
  defaultValue = (_) => this.value()

  i18n = (path) =>
    this.I18n.t(this.props.parent.state.response.locale, `output.${path}`, {
      attribute: this.title(),
    })

  title = (_) => this.props.attribute.title

  name = (_) => this.props.attribute.name

  value = (_) => this.props.model[this.name()]

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>
      <input
        id={this.name()}
        defaultValue={this.defaultValue()}
        readOnly
        type='text'
        className='bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
      />
    </div>
  )
}
