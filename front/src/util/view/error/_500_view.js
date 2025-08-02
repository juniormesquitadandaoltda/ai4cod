import ApplicationView from '@/util/view/application_view'

export default class _500View extends ApplicationView {
  index = (_) =>
    this.setState({
      response: {
        pages: [],
        locale: 'pt-BR',
        timezone: 'Brasilia',
      },
      loading: false,
      status: 500,
    })

  init = this.index

  name = '_500'
}
