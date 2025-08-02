import ApplicationView from '@/util/view/application_view'
import ReferenceView from './_reference_view'

export default class FormView extends ApplicationView {
  state = {
    ...this.state,
    searchReference: null,
  }

  get = (_) => this.request(this.Helper.Next.Router.asPath)

  attachments = (_) => this.model().attachments || []

  onSubmit = async (event) => {
    event.preventDefault()

    this.attachments().length > 0 ? this.onSubmitAttachments(event) : this.onSubmitStandard(event)
  }

  onSubmitStandard = async (event) => {
    event.preventDefault()

    await this.request(
      {
        ...this.submitPath(),
        data: {
          model: { ...this.model() },
          authenticity_token: this.authenticityToken(),
        },
      },
      ({ open, notice }) => {
        notice &&
          this.layout().popup.new({
            message: notice,
            confirm: this.get,
            exit: this.goBack,
          })

        open && window.open(open, '_blank')
      },
    )
  }

  onSubmitAttachments = async (event) => {
    event.preventDefault()

    for (const index in this.attachments()) {
      const attachment = this.attachments()[index]

      const isLast = index === (this.attachments().length - 1).toString()

      await this.request(
        {
          method: 'post',
          url: '/standard/archives',
          data: {
            model: {
              record: this.model().record,
              filename: attachment.filename,
              base64: attachment.base64,
            },
            authenticity_token: this.authenticityToken(),
          },
          skipState: !isLast,
        },
        ({ notice }) => {
          isLast &&
            notice &&
            this.layout().popup.new({
              message: notice,
              confirm: this.get,
              exit: (_) => window.close(),
            })
        },
        (data) => {
          attachment.errors = data.error
        },
      )
    }
  }

  searchReference = (attribute) => this.setState({ searchReference: attribute })

  selectReference = (attribute, value) => this.updateModel({ [attribute.name]: value })

  updateModel = (attributes) =>
    this.setState((state) => ({
      response: {
        ...state.response,
        model: { ...state.response.model, ...attributes },
      },
      searchReference: null,
    }))

  submitPath = (_) => this.paths().filter((p) => ['post', 'put'].includes(p.method))[0] || {}
  actionsPaths = (_) => this.paths().filter((p) => !['post', 'put'].includes(p.method))

  goBack = (_) => this.Helper.Next.Router.push(this.paths()[0].url)

  init = this.get

  error = (_) => (this.state.response.error || {}).subscription

  template = (_) => (
    <div key={this.state.currentTime} className='w-full'>
      <h4 className='text-2xl font-bold dark:text-white mb-4'>{this.i18n('title')}</h4>
      {this.error() && <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error()}</span>}

      {!this.state.searchReference && (
        <>
          <form onSubmit={this.onSubmit.bind(this)}>
            {this.attributes(this.ApplicationComponent.Input).map((attribute, index) => (
              <attribute.Component key={index} attribute={attribute} parent={this} />
            ))}
            <div className='mt-6'>
              <this.Helper.Tailwind.Button.Default type='button' onClick={this.componentDidMount.bind(this)}>
                {this.i18n('reset')}
              </this.Helper.Tailwind.Button.Default>
              <this.Helper.Tailwind.Button.Default type='submit'>
                {this.submitPath().title}
              </this.Helper.Tailwind.Button.Default>
            </div>
          </form>

          <div className='mt-2'>
            {this.actionsPaths().map((path, index) =>
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
        </>
      )}

      {this.state.searchReference && (
        <div className='mt-6 mb-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
          <ReferenceView
            attribute={this.state.searchReference}
            controller={this.props.controller}
            layout={this.props.layout}
            parent={this}
          />
        </div>
      )}
    </div>
  )
}
