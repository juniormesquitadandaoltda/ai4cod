import ApplicationView from '@/util/view/application_view'

export default class IndexView extends ApplicationView {
  defaultState = {
    ...this.state,
    filter: {
      sort: 'id',
      order: 'asc',
      page: '1',
      limit: '25',
    },
    tab: 'table',
    action: null,
  }

  state = this.defaultState

  name = 'index'

  index = async (_) => {
    await this.Helper.Next.Router.push(
      [this.Helper.Next.Router.route, decodeURIComponent(new URLSearchParams(this.state.filter).toString())]
        .filter((s) => !!s)
        .join('?'),
      null,
      { shallow: true },
    )
    await this.request(this.Helper.Next.Router.asPath, (data) => this.setState({ tab: 'table' }))
  }

  onSubmit = (_) => {
    event.preventDefault()
    this.index()
  }

  tab = (name) => {
    event.preventDefault()

    this.setState({ tab: name })
  }

  tabClass = (name) =>
    name === this.state.tab
      ? 'inline-block p-4 text-blue-600 bg-gray-100 rounded-t-lg active dark:bg-gray-800 dark:text-blue-500'
      : 'inline-block p-4 rounded-t-lg hover:text-gray-600 hover:bg-gray-50 dark:hover:bg-gray-800 dark:hover:text-gray-300'

  contentClass = (name) => (name === this.state.tab ? '' : 'hidden')

  reset = (_) => {
    this.setState(this.defaultState, this.index.bind(this))
  }

  actionClass = (index) =>
    this.state.action === index
      ? 'absolute z-10 mt-6 mr-3 bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600 block'
      : 'absolute z-10 mt-6 mr-3 bg-white rounded divide-y divide-gray-100 shadow dark:bg-gray-700 dark:divide-gray-600 hidden'

  onClickAction = (_) => {
    const action = parseInt(event.target.dataset.action)

    if (action === NaN || this.state.action === action) this.setState({ action: null, clearAction: false })
    else this.setState({ action: action, clearAction: true })
  }

  init = (_) => this.updateFilter(this.Helper.Next.Router.query, this.index.bind(this))

  actions = (model, index) => (
    <td className='px-5 py-2 text-sm border-b dark:border-gray-700'>
      {(model.paths.filter((path) => path.name !== 'show').length > 0 && (
        <div className='flex flex-col items-center justify-between'>
          <button
            data-action={index}
            className='inline-flex items-center p-0.5 text-sm font-medium text-center text-gray-500 hover:text-gray-800 rounded-lg focus:outline-none dark:text-gray-400 dark:hover:text-gray-100'
            type='button'
          >
            <svg
              data-action={index}
              className='w-5 h-5'
              aria-hidden='true'
              fill='currentColor'
              viewBox='0 0 20 20'
              xmlns='http://www.w3.org/2000/svg'
            >
              <path
                data-action={index}
                d='M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z'
              />
            </svg>
          </button>
          <div className={this.actionClass(index)}>
            <ul className='py-1 text-sm text-gray-700 dark:text-gray-200'>
              {model.paths
                .filter((path) => path.name !== 'show')
                .map((path, index) => (
                  <li key={index}>
                    {path.method === 'get' ? (
                      <this.Helper.Tailwind.Link.Action.Default href={path.url} target={path.target}>
                        {path.title}
                      </this.Helper.Tailwind.Link.Action.Default>
                    ) : (
                      <this.Helper.Tailwind.Link.Action.Request
                        href={path.url}
                        onClick={this.onClickRequest.bind(this, {
                          path,
                          success: this.index,
                        })}
                      >
                        {path.title}
                      </this.Helper.Tailwind.Link.Action.Request>
                    )}
                  </li>
                ))}
            </ul>
          </div>
        </div>
      )) || <>&nbsp;</>}
    </td>
  )

  template = (_) => (
    <div key={this.state.currentTime} onClick={this.onClickAction.bind(this)} className='w-full'>
      <h4 className='text-2xl font-bold dark:text-white mt-4 mb-4'>{this.i18n('title')}</h4>

      <ul className='flex flex-wrap text-sm font-medium text-center text-gray-500 border-b border-gray-200 dark:border-gray-700 dark:text-gray-400'>
        <li className='mr-2'>
          <button type='button' className={this.tabClass('table')} onClick={this.tab.bind(this, 'table')}>
            {this.i18n('tab.table')}
          </button>
        </li>
        <li className='mr-2'>
          <button type='button' className={this.tabClass('filter')} onClick={this.tab.bind(this, 'filter')}>
            {this.i18n('tab.filter')}
          </button>
        </li>
      </ul>

      <form onSubmit={this.onSubmit.bind(this)}>
        <div className={this.contentClass('filter')}>
          {this.attributes(this.ApplicationComponent.Filter)
            .filter((attribute) => attribute.searchable)
            .map((attribute, index) => (
              <attribute.Component key={index} attribute={attribute} parent={this} />
            ))}

          <div className='mt-6'>
            <this.Helper.Tailwind.Button.Default type='button' onClick={this.reset.bind(this)}>
              {this.i18n('reset')}
            </this.Helper.Tailwind.Button.Default>
            <this.Helper.Tailwind.Button.Default type='submit'>
              {this.i18n('search')}
            </this.Helper.Tailwind.Button.Default>
          </div>
        </div>

        <div className={this.contentClass('table')}>
          <div className='relative overflow-x-auto'>
            <table className='w-full flex flex-row flex-no-wrap text-sm text-left text-gray-500 dark:text-gray-400 mb-4'>
              <thead className='text-xs text-gray-700 uppercase dark:text-gray-400'>
                {this.models().map((model, index) => (
                  <tr key={index} className='bg-gray-200 dark:bg-gray-700 flex flex-col flex-no wrap md:table-row mb-4'>
                    {this.attributes()
                      .filter((attribute) => attribute.listable)
                      .map((attribute, index) => (
                        <th key={index} className='px-5 py-2.5 text-sm font-bold border-b dark:text-white'>
                          <this.ApplicationComponent.Filter.sort attribute={attribute} parent={this} />
                        </th>
                      ))}
                    <th className='px-5 py-2.5 text-sm font-bold border-b dark:text-white'>
                      <button type='button'></button>
                    </th>
                  </tr>
                ))}
              </thead>

              <tbody className='flex-1 md:flex-none'>
                {this.models().map((model, index) => (
                  <tr
                    key={index}
                    className='flex flex-col flex-no wrap md:table-row bg-white dark:bg-gray-800 hover:bg-gray-100 hover:text-gray-700 dark:hover:bg-gray-700 dark:hover:text-gray-100 mb-4'
                  >
                    {this.attributes(this.ApplicationComponent.Cell)
                      .filter((attribute) => attribute.listable)
                      .map((attribute, index) => (
                        <attribute.Component key={index} model={model} attribute={attribute} parent={this} />
                      ))}
                    {this.actions(model, index)}
                  </tr>
                ))}
              </tbody>
            </table>

            <table className='w-full text-sm text-left text-gray-500 dark:text-gray-400 mb-7'>
              <tfoot>
                <tr>
                  <td colSpan={this.attributes().filter((attribute) => attribute.listable).length + 1}>
                    <this.ApplicationComponent.Filter.pagination parent={this} />
                  </td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </form>

      <div className='mt-2'>
        {this.paths().map((path, index) =>
          path.method === 'get' ? (
            <this.Helper.Tailwind.Link.Default key={index} href={path.url}>
              {path.title}
            </this.Helper.Tailwind.Link.Default>
          ) : (
            <this.Helper.Tailwind.Button.Link
              key={index}
              type='button'
              onClick={this.onClickRequest.bind(this, { path })}
            >
              {path.title}
            </this.Helper.Tailwind.Button.Link>
          ),
        )}
      </div>
    </div>
  )
}
