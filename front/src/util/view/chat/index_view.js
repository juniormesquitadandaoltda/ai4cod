import ApplicationBase from '@/util/base/application_base'

export default class ChatView extends ApplicationBase {
  state = {
    ...this.state,
    response: {
      locale: 'pt-BR',
      title: 'AI for Code'
    },
    messages: [],
    isCopying: false,
    isLoading: false,
    domain: 'ai4cod.com',
    currentTime: new Date().getTime()
  }

  termsPolicesURL = (path) => path

  i18n = (path, options = {}) =>
    this.I18n.t(this.state.response?.locale, `views.${this.name}.${path}`, {
      title: this.title(),
      ...options,
    })

  name = 'chat'

  title = (_) => this.state.response?.title

  componentDidMount = (_) => {
    document.getElementById('input').focus()
  }

  render = (_) => this.state.response && this.template()

  template = (_) => (
    <div key={this.state.currentTime} className='w-full'>
      { this.terminal() }
    </div>
  )

  terminal = (_) => (
    <div className='w-full h-screen bg-black text-green-400 font-mono flex flex-col select-text'>
      <h1 className='text-center text-4xl py-8 flex items-center justify-center gap-3'>
        <img src='/favicon.svg' alt='AI4COD' width='64' height='64' />
        {this.title()}
      </h1>

      <div className='text-center text-lg mb-4 flex items-center justify-center gap-2'>
        <span className={`transition-colors duration-300 ${this.state.isCopying ? 'text-green-400' : 'text-gray-400'}`}>
          {this.state.domain}
        </span>
        <a
          className='text-gray-500 hover:text-green-400 transition-colors cursor-pointer'
          onClick={this.copyToClipboard.bind(this)}
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path d="M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92s2.92-1.31 2.92-2.92S19.61 16.08 18 16.08z"/>
          </svg>
        </a>
      </div>

      <div className='px-4 overflow-y-auto'>
        {this.state.messages.map((msg, index) => (
          (index % 2 === 0 && (
            <div key={index} className='mb-4'>
              <div className='text-cyan-400 text-right'>{msg}</div>
            </div>
          )) || (
            <div key={index} className='mb-4'>
              <div className='text-green-400 text-left'>{msg}</div>
            </div>
          )
        ))}

        {this.state.isLoading && (
          <div className='mb-4 flex items-center gap-2'>
            <div className='flex space-x-1'>
              <div className='w-2 h-2 bg-green-400 rounded-full animate-bounce'></div>
              <div className='w-2 h-2 bg-green-400 rounded-full animate-bounce' style={{animationDelay: '0.1s'}}></div>
              <div className='w-2 h-2 bg-green-400 rounded-full animate-bounce' style={{animationDelay: '0.2s'}}></div>
            </div>
          </div>
        )}
      </div>

      <div className='w-full px-4 py-4'>
        <textarea
          id='input'
          className='bg-transparent text-cyan-400 outline-none border border-gray-600 rounded-lg font-mono w-full min-h-[40px] max-h-[200px] resize-none p-3'
          placeholder='...'
          disabled={this.state.isLoading}
          autoComplete="off"
          rows={1}
          onInput={(e) => {
            e.target.style.height = 'auto'
            e.target.style.height = Math.min(e.target.scrollHeight, 200) + 'px'
          }}
          onKeyPress={(e) => {
            if (e.key === 'Enter' && (e.ctrlKey || e.metaKey)) {
              e.preventDefault()
              this.handleMessage(e.target.value)
            }
          }}
        />
      </div>

      <div className='flex justify-end w-full px-4 pb-4'>
        <div className='flex flex-col items-center gap-1'>
          <button
            onClick={() => this.handleMessage(document.getElementById('input').value)}
            disabled={this.state.isLoading}
            className='text-gray-500 hover:text-green-400 transition-colors p-3 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg border border-gray-600 hover:border-green-400'
          >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/>
            </svg>
          </button>
          <span className='text-gray-600 text-xs whitespace-nowrap'>
            {navigator.userAgent.includes('Mac') ? 'Cmd+Enter' : 'Ctrl+Enter'}
          </span>
        </div>
      </div>

      <footer className=''>
        <this.Helper.Tailwind.Link.Default
          href={this.termsPolicesURL('/cookies_policy')}
          className='block text-sm text-gray-500 text-center dark:text-gray-400 underline'
        >
          {this.i18n('cookies_policy')}
        </this.Helper.Tailwind.Link.Default>
        <this.Helper.Tailwind.Link.Default
          href={this.termsPolicesURL('/privacy_policy')}
          className='block text-sm text-gray-500 text-center dark:text-gray-400 underline'
        >
          {this.i18n('privacy_policy')}
        </this.Helper.Tailwind.Link.Default>
        <this.Helper.Tailwind.Link.Default
          href={this.termsPolicesURL('/use_terms')}
          className='block text-sm text-gray-500 text-center dark:text-gray-400 underline'
        >
          {this.i18n('use_terms')}
        </this.Helper.Tailwind.Link.Default>
        <span className='block text-sm text-gray-500 text-center dark:text-gray-400'>{this.i18n('footer')}</span>
        <span className='block text-sm text-gray-500 text-center dark:text-gray-400'>{this.i18n('release')}</span>
      </footer>
    </div>
  )

  handleMessage = (text) => {
    if (!text.trim() || this.state.isLoading) return

    const textarea = document.getElementById('input')
    textarea.value = ''
    textarea.style.height = 'auto'

    this.setState({ isLoading: true, messages: [...this.state.messages, text] })

    setTimeout(() => {
      const reversedText = text.split('').reverse().join('')

      this.setState({
        messages: [...this.state.messages, reversedText],
        isLoading: false
      })

      setTimeout(() => {
        textarea.focus()
      }, 100)

    }, 1000)
  }

  copyToClipboard = (event) => {
    event.preventDefault()

    this.setState({ isCopying: true })

    if (navigator.clipboard) {
      navigator.clipboard.writeText(this.state.domain).then(() => {
        setTimeout(() => {
          this.setState({ isCopying: false })
        }, 200)
      }).catch(err => {
        this.setState({ isCopying: false })
      })
    } else {
      const textArea = document.createElement('textarea')
      textArea.value = this.state.domain
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand('copy')
      document.body.removeChild(textArea)
      setTimeout(() => {
        this.setState({ isCopying: false })
      }, 200)
    }
  }
}
