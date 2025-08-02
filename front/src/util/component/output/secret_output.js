import ApplicationOutput from './application_output'

export default class SecretOutput extends ApplicationOutput {
  state = {
    show: false,
  }

  type = (_) => (this.state.show ? 'text' : 'password')

  onClickShow = (_) => this.setState({ show: !this.state.show })

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <div className='hidden'>
        <input type='password' tabIndex='-1' />
      </div>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>
      <div className='flex'>
        <input
          id={this.name()}
          defaultValue={this.defaultValue()}
          type={this.type()}
          autoComplete='new-password'
          readOnly
          className='rounded-none rounded-l-lg bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
        />
        <button
          onClick={this.onClickShow.bind(this)}
          type='button'
          className='inline-flex items-center px-3 text-sm text-gray-900 bg-gray-200 border border-l-0 border-gray-300 rounded-r-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600'
        >
          {this.state.show && (
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
                d='M3.98 8.223A10.477 10.477 0 001.934 12C3.226 16.338 7.244 19.5 12 19.5c.993 0 1.953-.138 2.863-.395M6.228 6.228A10.45 10.45 0 0112 4.5c4.756 0 8.773 3.162 10.065 7.498a10.523 10.523 0 01-4.293 5.774M6.228 6.228L3 3m3.228 3.228l3.65 3.65m7.894 7.894L21 21m-3.228-3.228l-3.65-3.65m0 0a3 3 0 10-4.243-4.243m4.242 4.242L9.88 9.88'
              ></path>
            </svg>
          )}

          {!this.state.show && (
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
                d='M2.036 12.322a1.012 1.012 0 010-.639C3.423 7.51 7.36 4.5 12 4.5c4.638 0 8.573 3.007 9.963 7.178.07.207.07.431 0 .639C20.577 16.49 16.64 19.5 12 19.5c-4.638 0-8.573-3.007-9.963-7.178z'
              ></path>
              <path strokeLinecap='round' strokeLinejoin='round' d='M15 12a3 3 0 11-6 0 3 3 0 016 0z'></path>
            </svg>
          )}
        </button>
      </div>
    </div>
  )
}
