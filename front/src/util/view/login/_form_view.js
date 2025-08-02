import ApplicationView from '@/util/view/application_view'

export default class FormView extends ApplicationView {
  get = (_) => this.request(this.Helper.Next.Router.asPath)

  name = (_) => this.Helper.Next.Router.asPath.replaceAll('/', '.')

  onSubmit = (_) =>
    this.onEventSafe((_) =>
      this.request({
        ...this.submitPath(),
        data: {
          user: this.model(),
          authenticity_token: this.authenticityToken(),
        },
      }),
    )

  updateModel = (attributes) =>
    this.setState((state) => ({
      response: {
        ...state.response,
        model: { ...state.response.model, ...attributes },
      },
    }))

  submitPath = (_) => this.paths().filter((p) => ['post', 'put'].includes(p.method))[0] || {}
  actionsPaths = (_) => this.paths().filter((p) => !['post', 'put'].includes(p.method))
  submitTitle = (_) => this.submitPath()?.title

  title = (_) => this.state.response?.title

  init = async (_) => {
    await this.get()
    this.updateModel(this.Helper.Next.Router.query)
  }

  template = (_) => (
    <div className='w-full m-auto bg-white rounded-lg border border-gray-200 dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700'>
      <div className='p-5 space-y-5'>
        <h1 className='text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white'>
          {this.title()}
        </h1>
        <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.errorBase()}</span>

        <form onSubmit={this.onSubmit.bind(this)}>
          {this.attributes(this.ApplicationComponent.Input).map((attribute, index) => (
            <attribute.Component key={index} attribute={attribute} parent={this} />
          ))}

          <div className='mt-5'>
            <this.Helper.Tailwind.Button.Default
              type='submit'
              className='w-full text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-primary-600 dark:hover:bg-primary-700 dark:focus:ring-primary-800'
            >
              {this.submitTitle()}
            </this.Helper.Tailwind.Button.Default>
          </div>
        </form>

        <div className='mt-1 space-y-2'>
          {this.actionsPaths().map((path, index) => (
            <div key={index}>
              {path.method === 'get' ? (
                <this.Helper.Tailwind.Link.Default href={path.url}>{path.title}</this.Helper.Tailwind.Link.Default>
              ) : (
                <this.Helper.Tailwind.Button.Link type='button' onClick={this.onClickRequest.bind(this, { path })}>
                  {path.title}
                </this.Helper.Tailwind.Button.Link>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
