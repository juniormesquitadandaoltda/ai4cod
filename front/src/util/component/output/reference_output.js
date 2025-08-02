import ApplicationOutput from './application_output'
import StringOutput from './string_output'

export default class ReferenceOutput extends ApplicationOutput {
  defaultValue = (_) =>
    this.value()
      ? `${this.value().id || this.value().uuid}: ${this.value()[this.props.attribute.reference.name] || this.value().email}`
      : null

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>
      <div className='flex'>
        <input
          id={this.name()}
          defaultValue={this.defaultValue()}
          readOnly
          type='text'
          className='rounded-l-lg bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
        />
      </div>
    </div>
  )
}
