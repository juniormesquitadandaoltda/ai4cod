import ApplicationFilter from './application_filter'

export default class BooleanFilter extends ApplicationFilter {
  checked = (value) => this.defaultValue('is') === value

  render = (_) => (
    <div className='mt-6'>
      <label htmlFor={this.name('is')} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>

      <div className='p-4 border border-gray-200 rounded dark:border-gray-700'>
        <ul className='items-center w-full text-sm font-medium text-gray-900 border border-gray-200 rounded-lg sm:flex dark:bg-gray-700 dark:border-gray-600 dark:text-white'>
          <li className='w-full border-b border-gray-200 sm:border-b-0 sm:border-r dark:border-gray-600'>
            <div className='flex items-center pl-3'>
              <input
                id={this.name('is')}
                checked={this.checked(undefined)}
                onChange={this.onChange.bind(this, 'is')}
                type='radio'
                name={this.name('is')}
                value=''
                className='w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500'
              />
              <label
                htmlFor={this.name('is')}
                className='w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300'
              >
                {this.i18n('option.all')}
              </label>
            </div>
          </li>
          <li className='w-full border-b border-gray-200 sm:border-b-0 sm:border-r dark:border-gray-600'>
            <div className='flex items-center pl-3'>
              <input
                id={this.name('yes')}
                checked={this.checked('true')}
                onChange={this.onChange.bind(this, 'is')}
                type='radio'
                name={this.name('is')}
                value='true'
                className='w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500'
              />
              <label
                htmlFor={this.name('yes')}
                className='w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300'
              >
                {this.i18n('option.yes')}
              </label>
            </div>
          </li>
          <li className='w-full dark:border-gray-600'>
            <div className='flex items-center pl-3'>
              <input
                id={this.name('no')}
                checked={this.checked('false')}
                onChange={this.onChange.bind(this, 'is')}
                type='radio'
                name={this.name('is')}
                value='false'
                className='w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500'
              />
              <label
                htmlFor={this.name('no')}
                className='w-full py-3 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300'
              >
                {this.i18n('option.no')}
              </label>
            </div>
          </li>
        </ul>
        <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error('is')}</span>
      </div>
    </div>
  )
}
