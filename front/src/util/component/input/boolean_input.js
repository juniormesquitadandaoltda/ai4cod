import ApplicationInput from './application_input'

export default class BooleanInput extends ApplicationInput {
  parse = (event) => event.target.checked

  label = (_) => this.i18n('option.yes')

  titleWithLinks = (_) => {
    if (this.title().includes('COOKIES')) {
      const texts = this.title().split(/COOKIES|PRIVACY|TERMS/)

      return (
        <>
          <span>{texts[0]}</span>
          <this.Helper.Tailwind.Link.Default
            href='/cookies_policy'
            className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
            target='_blank'
          >
            {this.i18n('cookies')}
          </this.Helper.Tailwind.Link.Default>
          <span>{texts[1]}</span>
          <this.Helper.Tailwind.Link.Default
            href='/privacy_policy'
            className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
            target='_blank'
          >
            {this.i18n('privacy')}
          </this.Helper.Tailwind.Link.Default>
          <span>{texts[2]}</span>
          <this.Helper.Tailwind.Link.Default
            href='/use_terms'
            className='font-medium text-blue-600 dark:text-blue-500 hover:underline'
            target='_blank'
          >
            {this.i18n('terms')}
          </this.Helper.Tailwind.Link.Default>
          <span>{texts[3]}</span>
        </>
      )
    }

    return this.title()
  }

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.titleWithLinks()}
      </label>

      <div>
        <div className='flex'>
          <ul className='items-center w-full text-sm font-medium text-gray-900 border border-gray-200 rounded-lg sm:flex dark:bg-gray-700 dark:border-gray-600 dark:text-white'>
            <li className='w-full border-gray-200 dark:border-gray-600'>
              <div className='flex items-center pl-3'>
                <input
                  id={this.name()}
                  checked={this.defaultValue()}
                  onChange={this.onChange.bind(this)}
                  type='checkbox'
                  className='w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600'
                />
                <label
                  htmlFor={this.name()}
                  className='w-full p-2.5 ml-2 text-sm font-medium text-gray-900 dark:text-gray-300'
                >
                  {this.label()}
                </label>
              </div>
            </li>
          </ul>
        </div>
      </div>

      <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error()}</span>
    </div>
  )
}
