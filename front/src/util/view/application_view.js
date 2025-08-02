import ApplicationBase from '@/util/base/application_base'
import ApplicationComponent from '@/util/component/application_component'

export default class ApplicationView extends ApplicationBase {
  ApplicationComponent = ApplicationComponent

  state = {
    response: null,
    currentTime: new Date().getTime(),
  }

  _setState = this.setState

  setState = async (newState, callback) => {
    await this._setState(newState, callback)

    if (newState.response?.pages) this.controller().setState({ pages: newState.response.pages })

    if (newState.response?.locale)
      this.layout().setState({
        locale: newState.response.locale,
        howTo: this.name === 'reference' ? this.layout().state.howTo : newState.response.how_to,
      })

    if (newState.status) setTimeout(() => this.layout().setState({ loading: false, status: newState.status }), 250)
  }

  request = async (params, success, fail) => {
    this.layout().setState({ loading: true })
    let response = null

    try {
      response = await this.Helper.Axios(params)

      const { notice, redirect } = response.data

      if (success) redirect ? this.Helper.Next.Router.push(redirect) : success(response.data)
      else if (notice)
        this.layout().popup.new({
          message: notice,
          exit: (_) => {
            if (redirect) this.Helper.Next.Router.push(redirect)
          },
        })
      else if (redirect) this.Helper.Next.Router.push(redirect)
    } catch (error) {
      response = error.response
      const { alert, redirect } = response.data

      if (fail) fail(response.data)
      else if (alert)
        this.layout().popup.new({
          message: alert,
          exit: (_) => {
            if (redirect) this.Helper.Next.Router.push(redirect)
          },
        })
    }

    // if (!params.skipState || (response.status !== 200 && params.url !== '/standard/archives'))

    if (this.name === 'home' && response.status !== 200) {
      response.status = 200
      response.data = {
        pages: [
          {
            title: 'Home',
            method: 'get',
            url: '/',
          },
        ],
        locale: 'pt-BR',
        timezone: 'Brasilia',
        models: [],
        count: 1000,
      }
    }

    this.setState({
      response: { ...this.state.response, ...response.data },
      status: response.status,
      currentTime: new Date().getTime(),
    })
  }

  // download = async (params) => {
  //   this.layout().setState({ loading: true })

  //   try {
  //     const response = await this.Helper.Axios(params)

  //     this.Helper.Next.Router.push(response.data.model.url)
  //   } catch (error) {
  //     this.layout().popup.new({ message: error?.response?.data || error?.message })
  //   }

  //   this.layout().setState({ loading: false })
  // }

  layout = (_) => this.props.layout
  controller = (_) => this.props.controller

  i18n = (path, options = {}) =>
    this.I18n.t(this.state.response?.locale, `views.${this.name}.${path}`, {
      title: this.title(),
      ...options,
    })

  title = (_) => this.state.response?.title

  name = null

  models = (_) => this.state.response?.models || []

  model = (_) => this.state.response?.model || {}

  authenticityToken = (_) => this.state.response?.authenticity_token

  filter = (_) => this.state.filter || {}

  updateFilter = (attributes, callback) =>
    this.setState(
      (state) => ({
        filter: { ...state.filter, ...attributes },
      }),
      callback,
    )

  paths = (_) => this.state.response?.paths || []

  attributes = (Component) =>
    (this.state.response?.attributes || []).map((attribute) => {
      if (attribute.type === 'boolean') this.model()[attribute.name] ||= false

      return {
        ...attribute,
        Component: Component ? Component[attribute.type] : null,
      }
    })

  onClickRequest = ({ path, success }) => {
    event.preventDefault()

    if (path.method === 'GET') this.request(path)
    else
      this.layout().popup.new({
        message: path.message,
        confirm: (_) =>
          this.request(
            {
              ...path,
              data: {
                authenticity_token: this.authenticityToken(),
              },
            },
            success,
          ),
        exit: (_) => {},
      })
  }

  errorBase = (_) => this.state.response?.error?.base

  onEventSafe = (callback) => {
    event.preventDefault()

    if (this.layout().state.popup || this.layout().state.loading) return

    callback()
  }

  componentDidMount = (_) => setTimeout(this.init, 100)

  template = (_) => null

  render = (_) => this.state.response && this.template()
}
