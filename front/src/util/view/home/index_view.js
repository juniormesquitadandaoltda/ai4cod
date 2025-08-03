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
    <div key={this.state.currentTime} className='w-full'>
      { this.terminal() }
    </div>
  )

  terminal = (_) => (
    <div className='w-full h-screen bg-black text-green-400 font-mono flex flex-col items-center justify-center'>
      <h1 className='text-center text-2xl mb-8'>AI for Code</h1>
      <div className='flex items-center w-full px-4'>
        <input
          ref={input => input && input.focus()}
          type='text'
          className='bg-transparent text-green-400 outline-none border-none font-mono w-full'
          placeholder='💤 ...'
          autoFocus
          onBlur={(e) => e.target.focus()}
        />
      </div>
    </div>
  )
}
