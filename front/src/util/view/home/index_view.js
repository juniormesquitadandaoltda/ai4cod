import ApplicationView from '@/util/view/application_view'

export default class IndexView extends ApplicationView {
  state = {
    ...this.state,
    filter: {
      query: '',
    },
  }

  index = (_) => this.request(null)

  init = (_) => {
    if (window.location.pathname === '/') {
      if (!!this.Helper.Next.Router.query) this.setState({ filter: this.Helper.Next.Router.query })

      this.index()
    } else if (
      ['/cookies', '/privacy', '/use', '/404', '/500'].find((path) => window.location.pathname.startsWith(path))
    ) {
      this.index()
    } else {
      window.location = '/404'
    }
  }

  name = 'home'

  template = (_) => (
    <div key={this.state.currentTime} className='w-full text-center'>
      { this.terminal() }
    </div>
  )

  terminal = (_) => (
    <>
      <h1>Terminal</h1>
    </>
  )
}
