import ApplicationView from '@/util/view/application_view'

export default class _404View extends ApplicationView {
  index = (_) =>
    this.setState({
      response: {
        pages: [],
        locale: 'pt-BR',
        timezone: 'Brasilia',
      },
      loading: false,
      status: 404,
    })

  init = this.index

  name = '_404'
}
