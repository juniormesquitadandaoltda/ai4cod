import ApplicationFilter from './application_filter'

export default class PaginationFilter extends ApplicationFilter {
  currentPage = (_) => parseInt(this.props.parent.state.filter.page)
  maxPage = (_) => Math.ceil(this.count() / this.perPage())
  perPage = (_) => parseInt(this.props.parent.state.filter.limit)
  count = (_) => this.props.parent.state.response?.count || 0

  onClick = (type) => {
    let page = this.currentPage()

    if (type === 'previous') page -= 1
    else page += 1

    if (page < 1 || page > this.maxPage()) event.preventDefault()
    else this.props.parent.updateFilter({ page: page })
  }

  disabled = (type) =>
    (type === 'previous' && this.currentPage() === 1) || (type === 'next' && this.currentPage() === this.maxPage())

  className = (type) =>
    ({
      previous: {
        true: 'cursor-not-allowed inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-gray-400 rounded-l hover:bg-gray-450 dark:bg-gray-400 dark:border-gray-350 dark:text-gray-800 dark:hover:bg-gray-350 dark:hover:text-white',
        false:
          'inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-gray-800 rounded-l hover:bg-gray-900 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white',
      },
      next: {
        true: 'cursor-not-allowed inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-gray-400 border-0 border-l border-gray-350 rounded-r hover:bg-gray-450 dark:bg-gray-400 dark:border-gray-350 dark:text-gray-800 dark:hover:bg-gray-700 dark:hover:text-white',
        false:
          'inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-gray-800 border-0 border-l border-gray-700 rounded-r hover:bg-gray-900 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white',
      },
    })[type][this.disabled(type)]

  render = (_) => (
    <div className='flex flex-col items-center'>
      <span className='text-sm text-gray-700 dark:text-gray-400'>
        {this.i18n('pagination.page')}{' '}
        <span className='font-semibold text-gray-900 dark:text-white'>{this.currentPage()}</span>/
        <span className='font-semibold text-gray-900 dark:text-white'>{this.maxPage()}</span>{' '}
        {this.i18n('pagination.of')} <span className='font-semibold text-gray-900 dark:text-white'>{this.count()}</span>{' '}
        {this.i18n('pagination.results')}
      </span>
      <div className='inline-flex mt-2 xs:mt-0'>
        <button onClick={this.onClick.bind(this, 'previous')} className={this.className('previous')}>
          <svg
            aria-hidden='true'
            className='w-5 h-5 mr-2'
            fill='currentColor'
            viewBox='0 0 20 20'
            xmlns='http://www.w3.org/2000/svg'
          >
            <path
              fillRule='evenodd'
              d='M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z'
              clipRule='evenodd'
            ></path>
          </svg>
          {this.i18n('pagination.previous')}
        </button>
        <button onClick={this.onClick.bind(this, 'next')} className={this.className('next')}>
          {this.i18n('pagination.next')}
          <svg
            aria-hidden='true'
            className='w-5 h-5 ml-2'
            fill='currentColor'
            viewBox='0 0 20 20'
            xmlns='http://www.w3.org/2000/svg'
          >
            <path
              fillRule='evenodd'
              d='M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-2.293-2.293a1 1 0 010-1.414z'
              clipRule='evenodd'
            ></path>
          </svg>
        </button>
      </div>
    </div>
  )
}
