import ApplicationBase from '@/util/base/application_base'

export default class ChatView extends ApplicationBase {
  state = {
    ...this.state,
    router: null,
    response: {
      locale: 'pt-BR',
      title: 'AI for Code'
    },
    messages: [],
    copying: false,
    loading: false,
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

  paths = (_) => this.state.response?.paths || []

  model = (_) => this.state.response?.model || {}

  title = (_) => this.state.response?.title

  pendingConsent = (_) => !this.state.consent && this.state.router && this.state.router.asPath.lastIndexOf('/') <= 1

  onClickConsent = (_) => {
    const consent = true

    localStorage.setItem('consent', true)

    this.setState({ consent })
  }

  componentDidMount = (_) => {
    this.setState({
      router: this.Helper.Next.Router,
      consent: localStorage.getItem('consent') === 'true',
      title:
        window.location.host.replace(':', '.').split('.').length < 3
          ? 'Tarefas de IA'
          : window.location.host.split('.')[0],
      description: 'Clique aqui. Tarefas de IA.',
      canonical: window.location.origin,
    })

    document.getElementById('input').focus()

    this.request({url: '/standard/session', method: 'get'}, ({model}) => {
      this.answer(this.i18n('welcome', {email: model.email}))
    }, () => {
      this.request({url: '/login/session/new', method: 'get'}, () => {
        this.answer(this.i18n('request_email_and_consent'))
      })
    })
  }

  logout = (_) => {
    event.preventDefault()

    this.request(
      {
        url: '/login/session',
        method: 'delete',
        data: {
          authenticity_token: this.authenticityToken(),
        },
      },
      () => {
        window.location.reload()
      }
    )
  }

  authenticityToken = (_) => this.state.response?.authenticity_token

  request = async (params, success, fail) => {
    this.setState({ loading: true })
    let response = null

    try {
      response = await this.Helper.Axios(params)

      if (success) success(response.data)
    } catch (error) {
      response = error.response
      if (fail) fail(response.data)
    }

    this.setState({
      response: { ...this.state.response, ...response.data, title: 'AI for Code' },
      status: response.status,
      currentTime: new Date().getTime(),
    })
  }

  handleMessage = (value) => {
    if (!value.trim() || this.state.loading) return

    document.getElementById('input').value = ''

    if (this.state.messages.length === 1 && this.state.messages[0] === this.i18n('request_email_and_consent')){
      this.setState({ loading: true, messages: [...this.state.messages, value] })

      this.request({
        url: '/login/session',
        method: 'put',
        data: {
          user: {
            email: value,
            policy_terms: true,
          },
          authenticity_token: this.authenticityToken(),
        },
      }, () => {
        this.answer(this.i18n('request_temp_password'))
      }, ({error}) => {
        this.setState({ loading: false, messages: [...this.state.messages, error.email] })
      })
    } else if (this.state.messages.length === 3 && this.state.messages[2] !== this.i18n('request_temp_password')) {
      this.setState({ messages: [this.state.messages[0]] }, () => {
        this.handleMessage(value)
      })
    } else if (this.state.messages.length === 3 && this.state.messages[2] === this.i18n('request_temp_password')) {
      this.setState({ loading: true, messages: [...this.state.messages, '*'] })

      this.request({
        url: '/login/session',
        method: 'post',
        data: {
          user: {
            email: this.state.messages[1],
            policy_terms: true,
            password: value,
          },
          authenticity_token: this.authenticityToken(),
        },
      }, ({redirect}) => {
        this.request({
          url: redirect,
          method: 'get',
        }, ({model}) => {
          this.setState({ loading: false, messages: [this.i18n('welcome', {email: model.email})]})
        })
      })
    } else if (this.state.messages.length === 5 && this.state.messages[2] === this.i18n('request_temp_password')) {
      this.setState({ messages: [this.state.messages[0], this.state.messages[1], this.state.messages[2]] }, () => {
        this.handleMessage(value)
      })
    } else {
      setTimeout(() => {
        const reversedText = value.split('').reverse().join('')

        this.answer(reversedText)
      }, 1000)
    }
  }

  answer = (text) => {
    this.setState({ loading: false, messages: [...this.state.messages, text] })

    setTimeout(() => {
      document.getElementById('input').focus()
    }, 100)
  }

  copyToClipboard = (event) => {
    event.preventDefault()

    this.setState({ copying: true })

    if (navigator.clipboard) {
      navigator.clipboard.writeText(this.state.domain).then(() => {
        setTimeout(() => {
          this.setState({ copying: false })
        }, 200)
      }).catch(err => {
        this.setState({ copying: false })
      })
    } else {
      const textArea = document.createElement('textarea')
      textArea.value = this.state.domain
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand('copy')
      document.body.removeChild(textArea)
      setTimeout(() => {
        this.setState({ copying: false })
      }, 200)
    }
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
        <span className={`transition-colors duration-300 ${this.state.copying ? 'text-green-400' : 'text-gray-400'}`}>
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
              {msg === this.i18n('request_email_and_consent') ? (
                <div className='text-green-400 text-left' dangerouslySetInnerHTML={{__html: msg}}></div>
              ) : (
                <div className='text-green-400 text-left'>{msg}</div>
              )}
            </div>
          )) || (
            <div key={index} className='mb-4'>
              <div className='text-cyan-400 text-right'>{msg}</div>
            </div>
          )
        ))}

        {this.state.loading && (
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
          height='auto'
          className='bg-transparent text-cyan-400 outline-none border border-gray-600 rounded-lg font-mono w-full min-h-[40px] max-h-[200px] resize-none p-3'
          placeholder='...'
          disabled={this.state.loading}
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
        {this.model().email && (
          <div className='flex flex-col items-center gap-1'>
            <button
              onClick={this.logout.bind(this)}
              disabled={this.state.loading}
              type='button'
              title='Logout'
              className='text-gray-500 hover:text-green-400 transition-colors p-3 disabled:opacity-50 disabled:cursor-not-allowed rounded-lg border border-gray-600 hover:border-green-400'
            >
            <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor">
              <path d="M16 13v-2H7V8l-5 4 5 4v-3z"/>
              <path d="M20 3h-9c-1.103 0-2 .897-2 2v4h2V5h9v14h-9v-4H9v4c0 1.103.897 2 2 2h9c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2z"/>
            </svg>
            </button>
          </div>
        )}

        <div className='flex flex-col items-center gap-1'>
          <button
            onClick={() => this.handleMessage(document.getElementById('input').value)}
            disabled={this.state.loading}
            type='button'
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

      {this.pendingConsent() && (
        <div
          tabIndex='-1'
          className='fixed z-50 flex flex-col md:flex-row justify-between w-[calc(100%-2rem)] p-4 -translate-x-1/2 bg-gray-50 border border-pink-500 rounded-lg shadow-sm lg:max-w-7xl left-1/2 bottom-[14.25rem] dark:bg-gray-700 dark:border-gray-600'
        >
          <div className='flex flex-col items-start mb-3 mr-4 md:items-center md:flex-row md:mb-0'>
            <p className='flex items-center mb-2 border-gray-200 md:pr-4 md:mr-4 md:border-r md:mb-0 dark:border-gray-600'>
              <span className='self-center text-lg font-semibold whitespace-nowrap dark:text-white'>
                {this.i18n('cookies_policy')}
              </span>
            </p>
            <p className='flex items-center text-sm font-normal text-gray-500 dark:text-gray-400'>
              <span>
                {this.i18n('cookies_policy_description_1')}
                <this.Helper.Tailwind.Link.Default
                  href={this.termsPolicesURL('/cookies_policy')}
                  className='text-sm text-gray-500 text-center dark:text-gray-400 underline'
                >
                  {this.i18n('cookies_policy')}
                </this.Helper.Tailwind.Link.Default>
                {this.i18n('cookies_policy_description_2')}
              </span>
            </p>
          </div>
          <div className='flex items-center flex-shrink-0'>
            <this.Helper.Tailwind.Button.Default
              onClick={this.onClickConsent.bind(this)}
              className='px-5 py-2 mr-2 text-xs font-medium text-white bg-blue-700 rounded-lg hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800'
            >
              {this.i18n('cookies_policy_button')}
            </this.Helper.Tailwind.Button.Default>
          </div>
        </div>
      )}

      <footer className='mt-4'>
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
}
