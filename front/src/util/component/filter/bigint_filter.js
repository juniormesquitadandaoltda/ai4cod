import ApplicationFilter from './application_filter'

export default class BigIntFilter extends ApplicationFilter {
  mask = (_) => {
    const masks = []
    const regex = /[0-9]/

    for (let i = 0; i < 18; i++) {
      masks.push(regex)
    }

    return masks
  }

  render = (_) => (
    <div className='mt-6'>
      <label htmlFor={this.name('is')} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>

      <div className='p-4 border border-gray-200 rounded dark:border-gray-700'>
        <div className='flex'>
          <label
            htmlFor={this.name('is')}
            className='inline-flex items-center px-3 text-sm text-gray-900 bg-gray-200 border border-r-0 border-gray-300 rounded-l-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600'
          >
            {this.i18n('title.is')}
          </label>
          <this.Helper.Next.InputMask
            id={this.name('is')}
            onChange={this.onChange.bind(this, 'is')}
            mask={this.mask()}
            maskPlaceholder={null}
            alwaysShowMask={false}
            defaultValue={this.defaultValue('is')}
            type='text'
            className='rounded-none rounded-r-lg bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
          />
        </div>
        <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error('is')}</span>
      </div>
    </div>
  )
}
