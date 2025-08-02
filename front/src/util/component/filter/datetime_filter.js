import ApplicationFilter from './application_filter'

export default class DatetimeFilter extends ApplicationFilter {
  parse = (event) => {
    const value = event.target.value

    if (value.includes('-')) return ''

    const d = value.replaceAll('-', '0').replace(' ', '/').replaceAll(':', '/').split('/')

    return `${d[2]}-${d[1]}-${d[0]} ${d[3]}:${d[4]}:${d[5]}`
  }

  render = (_) => (
    <>
      <div className='mt-6'>
        <label htmlFor={this.name('is')} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
          {this.title()}
        </label>

        <div className='p-4 border border-gray-200 rounded dark:border-gray-700'>
          <div className='grid gap-6 md:grid-cols-2'>
            {!this.isBlank() &&
              ['is', 'gt', 'lt', 'gte', 'lte'].map((suffix, index) => (
                <div key={index}>
                  <div className='flex'>
                    <label
                      htmlFor={this.name(suffix)}
                      className='inline-flex items-center px-3 text-sm text-gray-900 bg-gray-200 border border-r-0 border-gray-300 rounded-l-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600'
                    >
                      {this.i18n(`title.${suffix}`)}
                    </label>
                    <this.Helper.Next.InputMask
                      id={this.name(suffix)}
                      onChange={this.onChange.bind(this, suffix)}
                      mask={this.mask()}
                      maskPlaceholder='-'
                      alwaysShowMask={false}
                      defaultValue={this.defaultValue(suffix)}
                      type='text'
                      className='rounded-none rounded-r-lg bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
                    />
                  </div>
                  <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error(suffix)}</span>
                </div>
              ))}

            <div>
              <div className='flex'>
                <ul className='items-center w-full text-sm font-medium text-gray-900 border border-gray-200 rounded-lg sm:flex dark:bg-gray-700 dark:border-gray-600 dark:text-white'>
                  <li className='w-full border-gray-200 dark:border-gray-600'>
                    <div className='flex items-center pl-3'>
                      <input
                        id={this.name('blank')}
                        checked={this.isBlank()}
                        onChange={this.onChangeBlank.bind(this)}
                        name={this.name('blank')}
                        type='checkbox'
                        className='w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600'
                      />
                      <label
                        htmlFor={this.name('blank')}
                        className='w-full p-2.5 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300'
                      >
                        {this.i18n('option.blank')}
                      </label>
                    </div>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
