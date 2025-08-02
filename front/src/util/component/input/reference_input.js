import ApplicationInput from './application_input'

export default class ReferenceInput extends ApplicationInput {
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
          onChange={this.onChange.bind(this)}
          defaultValue={this.defaultValue()}
          readOnly
          type='text'
          className='rounded-none rounded-l-lg bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
        />
        {!this.readOnly() && (
          <button
            onClick={this.props.parent.searchReference.bind(this.props.parent, this.props.attribute)}
            type='button'
            className='inline-flex items-center px-3 text-sm text-gray-900 bg-gray-200 border border-l-0 border-gray-300 rounded-r-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600'
          >
            <svg
              aria-hidden='true'
              className='w-5 h-5'
              fill='none'
              stroke='currentColor'
              viewBox='0 0 24 24'
              xmlns='http://www.w3.org/2000/svg'
            >
              <path
                strokeLinecap='round'
                strokeLinejoin='round'
                strokeWidth='2'
                d='M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z'
              ></path>
            </svg>
          </button>
        )}
      </div>
      <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error()}</span>
    </div>
  )
}
