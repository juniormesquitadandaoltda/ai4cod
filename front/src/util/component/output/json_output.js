import ApplicationOutput from './application_output'

export default class JSONOutput extends ApplicationOutput {
  defaultValue = (_) => {
    const value = this.value()

    return !!value ? JSON.stringify(value) : ''
  }

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>
      <textarea
        id={this.name()}
        defaultValue={this.defaultValue()}
        readOnly
        rows='20'
        className='block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
      />
    </div>
  )
}
