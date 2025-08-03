import ApplicationView from '@/util/view/application_view'

export default class IndexView extends ApplicationView {
  state = {
    ...this.state,
    filter: {
      query: '',
    },
    messages: [],
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
    <div className='w-full h-screen bg-black text-green-400 font-mono flex flex-col'>
      <h1 className='text-center text-4xl py-8 flex items-center justify-center gap-3'>
        <img src='/favicon.svg' alt='AI4COD' width='64' height='64' />
        AI for Code
      </h1>

      <div className='px-4 overflow-y-auto'>
        {this.state.messages.map((msg, index) => (
          <div key={index} className='mb-4'>
            <div className='text-cyan-400'>Você: {msg.user}</div>
            <div className='text-green-400'>AI: {msg.ai}</div>
          </div>
        ))}
      </div>

      <div className='items-center w-full px-4 py-4'>
        <input
          ref={input => input && input.focus()}
          type='text'
          className='bg-transparent text-green-400 outline-none border-none font-mono w-full'
          placeholder='...'
          autoFocus
          onBlur={(e) => e.target.focus()}
          onKeyPress={(e) => e.key === 'Enter' && this.handleMessage(e.target.value)}
        />
      </div>
    </div>
  )

  handleMessage = (text) => {
    if (!text.trim()) return

    const reversedText = text.split('').reverse().join('')

    const newMessage = {
      user: text,
      ai: reversedText
    }

    this.setState({
      messages: [...this.state.messages, newMessage]
    })

    document.querySelector('input').value = ''
  }
}
