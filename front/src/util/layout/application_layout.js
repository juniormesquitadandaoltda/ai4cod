import ApplicationBase from '../base/application_base'
import Head from 'next/head'

export default class ApplicationLayout extends ApplicationBase {
  state = {
    router: null,
    menu: false,
    dark: false,
    loading: true,
    popup: null,
    status: 100,
    locale: 'pt-BR',
    timezone: 'Brasilia',
    consent: false,
    howTo: null,
    showHowTo: false,
    canonical: null,
    title: null,
  }

  componentDidMount = (_) => {
    if (window.location.host.replace('.com', '').includes('.'))
      window.location = `${window.location.protocol}//${window.location.host
        .split('.')
        .filter((h, i) => i > 0)
        .join(
          '.',
        )}/public/pages/${window.location.host.split('.')[0]}${window.location.pathname}${window.location.search}`
    else if (
      window.location.hostname.replace('.com', '').includes('.') &&
      window.location.pathname !== '/' &&
      !['/jobs', '/404', '/500'].find((path) => window.location.pathname.startsWith(path))
    )
      window.location = '/404'
    else
      this.setState({
        router: this.Helper.Next.Router,
        dark: localStorage.getItem('dark') === 'true',
        consent: localStorage.getItem('consent') === 'true',
        title:
          window.location.host.replace(':', '.').split('.').length < 3
            ? 'Tarefas de IA'
            : window.location.host.split('.')[0],
        description: 'Clique aqui. Tarefas de IA.',
        canonical: window.location.origin,
      })
  }

  waiting = (milliseconds) => setTimeout((_) => this.setState({ loading: false }), milliseconds)

  links = (_) =>
    this.props.pages.map((page) => {
      let className =
        'block py-2 pl-3 pr-4 text-gray-700 rounded hover:bg-gray-100 md:hover:bg-transparent md:border-0 md:hover:text-blue-700 md:p-0 dark:text-gray-400 md:dark:hover:text-white dark:hover:bg-gray-700 dark:hover:text-white md:dark:hover:bg-transparent'
      let current = false

      if (
        (page.class =
          this.state.router?.route === page.url || (page.url !== '/' && this.state.router?.route?.startsWith(page.url)))
      ) {
        className =
          'block py-2 pl-3 pr-4 text-white bg-blue-700 rounded md:bg-transparent md:text-blue-700 md:p-0 dark:text-white'
        current = true
      }

      page = { ...page, className, current }

      return page
    })

  onMenu = (_) => event.preventDefault()

  menuClass = (_) =>
    this.state.menu ? 'w-full md:block md:w-auto overflow-y-auto' : 'hidden w-full md:block md:w-auto overflow-y-auto'

  onTheme = (_) => {
    const dark = !this.state.dark

    if (dark) document.documentElement.classList.add('dark')
    else document.documentElement.classList.remove('dark')

    localStorage.setItem('dark', dark)

    this.setState({ dark })
  }

  onToggleMenu = (_) => this.setState({ menu: !this.state.menu })

  children = (_) => {
    const children = this.props.children || <></>
    return { ...children, props: { ...children.props, layout: this } }
  }

  howTo = (_) => this.state.howTo

  showHowTo = (_) => this.state.showHowTo

  onToggleShowHowTo = (_) => this.setState({ showHowTo: !this.state.showHowTo })

  i18n = (path) =>
    this.I18n.t(this.state.locale, `layouts.application.${path}`, {
      title: this.props.title,
    })

  popup = {
    new: (popup) => this.setState({ popup }),
    close: (_) => this.setState({ popup: null }),
    confirm: (_) => {
      this.popup.close()

      if (this.state.popup.confirm) this.state.popup.confirm()
    },
    exit: (_) => {
      setTimeout(this.popup.close, 100)

      if (this.state.popup.exit) this.state.popup.exit()
    },
    className: (_) =>
      this.state.status === 401
        ? 'bg-gray-100 dark:bg-opacity-80 fixed inset-0 z-40'
        : 'bg-gray-100 bg-opacity-50 dark:bg-opacity-80 fixed inset-0 z-40',
  }

  pendingConsent = (_) => !this.state.consent && this.state.router && this.state.router.asPath.lastIndexOf('/') <= 1

  onClickConsent = (_) => {
    const consent = true

    localStorage.setItem('consent', true)

    this.setState({ consent })
  }

  pageTitle = (_) => [this.state.title, ''].filter((t) => t).join(' | ')

  errorPath = (_) =>
    window.location.hostname.replace('.com', '').includes('.') || window.location.pathname.startsWith('/public/pages')
      ? '/'
      : '/login/session/new'

  errorLabel = (_) =>
    window.location.hostname.replace('.com', '').includes('.') || window.location.pathname.startsWith('/public/pages')
      ? this.i18n('error.back_home')
      : this.i18n('error.back_session')

  termsPolicesURL = (path) => path

  termsPolicesTarget = (_) => ''

  render = (_) => (
    <>
      <Head>
        <meta charSet='utf-8' />
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />

        <title>{this.pageTitle()}</title>

        <meta name='description' content={this.state.description} />
        <meta name='msapplication-TileColor' content='#ffffff' />
        <meta name='theme-color' content='#ffffff' />

        <link rel='icon' href='/assets/images/favicon.ico' type='image/x-icon' />
        <link rel='canonical' href={this.state.canonical} />

        {this.state.canonical &&
          window.location.host.replace(':', '.').split('.').length < 3 &&
          window.location.pathname === '/' && (
            <script id='website' type='application/ld+json'>
              {`
              {
                "@context": "https://schema.org",
                "@type": "BreadcrumbList",
                "itemListElement": [
                  {
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Registre-se ou faça login aqui",
                    "item": "https://aiforcod.com/login/session/new"
                  },
                ]
              }
            `}
            </script>
          )}
      </Head>
      <div className={[100, 404, 500].includes(this.state.status) ? 'hidden' : ''}>
        <nav className='bg-gray-50 border-b border-gray-200 px-2 sm:px-4 py-2.5 shadow rounded-b-lg dark:bg-gray-900 dark:border-gray-800'>
          <div className='container flex flex-wrap items-center justify-between mx-auto'>
            <this.Helper.Tailwind.Link.Default href='/' className='flex items-center'>
              <this.Helper.Next.Image
                src='/assets/images/logo.svg'
                className='h-6 mr-2'
                alt=''
                width={50}
                height={50}
                style={{ width: 'auto' }}
              />
              <span className='self-center text-sm font-semibold whitespace-nowrap dark:text-white'>
                {this.props.title}
              </span>
            </this.Helper.Tailwind.Link.Default>

            <div className='ml-auto'>
              <button
                onClick={this.onTheme.bind(this)}
                type='button'
                className='inline-flex items-center mr-2 text-gray-500 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-700 focus:outline-none focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-700 rounded-lg text-sm p-2.5'
              >
                {(this.state.dark && (
                  <svg className='w-5 h-5' fill='currentColor' viewBox='0 0 20 20' xmlns='http://www.w3.org/2000/svg'>
                    <path
                      d='M10 2a1 1 0 011 1v1a1 1 0 11-2 0V3a1 1 0 011-1zm4 8a4 4 0 11-8 0 4 4 0 018 0zm-.464 4.95l.707.707a1 1 0 001.414-1.414l-.707-.707a1 1 0 00-1.414 1.414zm2.12-10.607a1 1 0 010 1.414l-.706.707a1 1 0 11-1.414-1.414l.707-.707a1 1 0 011.414 0zM17 11a1 1 0 100-2h-1a1 1 0 100 2h1zm-7 4a1 1 0 011 1v1a1 1 0 11-2 0v-1a1 1 0 011-1zM5.05 6.464A1 1 0 106.465 5.05l-.708-.707a1 1 0 00-1.414 1.414l.707.707zm1.414 8.486l-.707.707a1 1 0 01-1.414-1.414l.707-.707a1 1 0 011.414 1.414zM4 11a1 1 0 100-2H3a1 1 0 000 2h1z'
                      fillRule='evenodd'
                      clipRule='evenodd'
                    ></path>
                  </svg>
                )) || (
                  <svg className='w-5 h-5' fill='currentColor' viewBox='0 0 20 20' xmlns='http://www.w3.org/2000/svg'>
                    <path d='M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z'></path>
                  </svg>
                )}
              </button>

              <button
                onClick={this.onToggleMenu.bind(this)}
                data-collapse-toggle='navbar-default'
                type='button'
                className='inline-flex items-center p-2 text-sm text-gray-500 rounded-lg md:hidden hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-200 dark:text-gray-400 dark:hover:bg-gray-700 dark:focus:ring-gray-600'
                aria-controls='navbar-default'
                aria-expanded='false'
              >
                <span className='sr-only'></span>
                <svg
                  className='w-6 h-6'
                  aria-hidden='true'
                  fill='currentColor'
                  viewBox='0 0 20 20'
                  xmlns='http://www.w3.org/2000/svg'
                >
                  <path
                    fillRule='evenodd'
                    d='M3 5a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 10a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1zM3 15a1 1 0 011-1h12a1 1 0 110 2H4a1 1 0 01-1-1z'
                    clipRule='evenodd'
                  ></path>
                </svg>
              </button>
            </div>

            <div className={this.menuClass()} id='navbar-default'>
              <ul className='flex flex-col p-2 mt-2 border border-gray-100 rounded-lg bg-gray-50 md:flex-row md:space-x-2 md:mt-0 text-sm md:font-medium md:border-0 md:bg-gray-50 dark:bg-gray-800 md:dark:bg-gray-900 dark:border-gray-700'>
                {this.links().map((link, index) => (
                  <li key={index}>
                    {link.current && link.url === this.state.router?.route ? (
                      <a href={link.url} className={link.className} disabled={true} onClick={this.onMenu.bind(this)}>
                        {link.title}
                      </a>
                    ) : (
                      <this.Helper.Next.Link
                        href={link.url}
                        className={link.className}
                        disabled={true}
                        target={link.target}
                      >
                        {link.title}
                      </this.Helper.Next.Link>
                    )}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </nav>

        <div className='px-6 py-2.5 rounded'>
          <div
            className='container flex flex-col flex-wrap items-start justify-start mx-auto'
            style={{ minHeight: '69vh' }}
          >
            {this.howTo() && (
              <div className='w-full mb-4'>
                <h2 onClick={this.onToggleShowHowTo.bind(this)}>
                  <button
                    type='button'
                    className='flex items-center justify-between w-full p-5 font-medium text-left text-gray-500 border border-gray-200 rounded-t-xl focus:ring-4 focus:ring-gray-200 dark:focus:ring-gray-800 dark:border-gray-700 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-gray-800'
                    data-accordion-target='#accordion-open-body-1'
                    aria-expanded='true'
                    aria-controls='accordion-open-body-1'
                  >
                    <span className='flex items-center'>
                      <svg
                        className='w-5 h-5 mr-2 shrink-0'
                        fill='currentColor'
                        viewBox='0 0 20 20'
                        xmlns='http://www.w3.org/2000/svg'
                      >
                        <path
                          fillRule='evenodd'
                          d='M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-3a1 1 0 00-.867.5 1 1 0 11-1.731-1A3 3 0 0113 8a3.001 3.001 0 01-2 2.83V11a1 1 0 11-2 0v-1a1 1 0 011-1 1 1 0 100-2zm0 8a1 1 0 100-2 1 1 0 000 2z'
                          clipRule='evenodd'
                        ></path>
                      </svg>{' '}
                      {this.i18n('how_to')}
                    </span>
                    {this.showHowTo() && (
                      <svg
                        className='w-6 h-6 rotate-180 shrink-0'
                        fill='currentColor'
                        viewBox='0 0 20 20'
                        xmlns='http://www.w3.org/2000/svg'
                      >
                        <path
                          fillRule='evenodd'
                          d='M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z'
                          clipRule='evenodd'
                        ></path>
                      </svg>
                    )}
                    {!this.showHowTo() && (
                      <svg
                        className='w-6 h-6 shrink-0'
                        fill='currentColor'
                        viewBox='0 0 20 20'
                        xmlns='http://www.w3.org/2000/svg'
                      >
                        <path
                          fillRule='evenodd'
                          d='M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z'
                          clipRule='evenodd'
                        ></path>
                      </svg>
                    )}
                  </button>
                </h2>
                {this.showHowTo() && (
                  <div aria-labelledby='accordion-open-heading-1'>
                    <div className='p-5 border border-gray-200 dark:border-gray-700 dark:bg-gray-900'>
                      {this.howTo().map((message, index) => (
                        <p key={index} className='mb-2 text-gray-500 dark:text-gray-400'>
                          {message}
                        </p>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            )}

            {this.children()}
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

        <footer className='p-2 bg-gray-50 border-t border-gray-200 rounded-t-lg md:py-4 dark:bg-gray-900 dark:border-gray-800'>
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

      {[404, 500].includes(this.state.status) && (
        <section className='bg-gray-50 dark:bg-gray-900'>
          <div className='py-8 px-4 mx-auto max-w-screen-xl lg:py-16 lg:px-6'>
            <div className='mx-auto max-w-screen-sm text-center'>
              <h1 className='mb-4 text-7xl tracking-tight font-extrabold lg:text-9xl text-primary-600 dark:text-primary-500'>
                {this.state.status}
              </h1>
              <p className='mb-4 text-3xl tracking-tight font-bold text-gray-900 md:text-4xl dark:text-white'>
                {this.i18n(`error.${this.state.status}.title`)}
              </p>
              <p className='mb-4 text-lg font-light text-gray-500 dark:text-gray-400'>
                {this.i18n(`error.${this.state.status}.description`)}
              </p>
              <this.Helper.Next.Link
                href={this.errorPath()}
                className='inline-flex text-white bg-primary-600 hover:bg-primary-800 focus:ring-4 focus:outline-none focus:ring-primary-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:focus:ring-primary-900 my-4'
              >
                {this.errorLabel()}
              </this.Helper.Next.Link>
            </div>
          </div>
        </section>
      )}

      {this.state.loading && (
        <div className='flex justify-center'>
          <div
            tabIndex='-1'
            aria-hidden='true'
            className='fixed top-0 left-0 right-0 z-50 w-full p-4 overflow-x-hidden overflow-y-auto md:inset-0 h-[calc(100%-1rem)] md:h-full'
          >
            <div className='relative'>
              <div className='text-center mt-60'>
                <div role='status'>
                  <svg
                    aria-hidden='true'
                    className='inline w-20 h-20 mr-2 text-gray-200 animate-spin dark:text-gray-600 fill-pink-600'
                    viewBox='0 0 100 101'
                    fill='none'
                    xmlns='http://www.w3.org/2000/svg'
                  >
                    <path
                      d='M100 50.5908C100 78.2051 77.6142 100.591 50 100.591C22.3858 100.591 0 78.2051 0 50.5908C0 22.9766 22.3858 0.59082 50 0.59082C77.6142 0.59082 100 22.9766 100 50.5908ZM9.08144 50.5908C9.08144 73.1895 27.4013 91.5094 50 91.5094C72.5987 91.5094 90.9186 73.1895 90.9186 50.5908C90.9186 27.9921 72.5987 9.67226 50 9.67226C27.4013 9.67226 9.08144 27.9921 9.08144 50.5908Z'
                      fill='currentColor'
                    />
                    <path
                      d='M93.9676 39.0409C96.393 38.4038 97.8624 35.9116 97.0079 33.5539C95.2932 28.8227 92.871 24.3692 89.8167 20.348C85.8452 15.1192 80.8826 10.7238 75.2124 7.41289C69.5422 4.10194 63.2754 1.94025 56.7698 1.05124C51.7666 0.367541 46.6976 0.446843 41.7345 1.27873C39.2613 1.69328 37.813 4.19778 38.4501 6.62326C39.0873 9.04874 41.5694 10.4717 44.0505 10.1071C47.8511 9.54855 51.7191 9.52689 55.5402 10.0491C60.8642 10.7766 65.9928 12.5457 70.6331 15.2552C75.2735 17.9648 79.3347 21.5619 82.5849 25.841C84.9175 28.9121 86.7997 32.2913 88.1811 35.8758C89.083 38.2158 91.5421 39.6781 93.9676 39.0409Z'
                      fill='currentFill'
                    />
                  </svg>
                  <span className='sr-only'>Loading...</span>
                </div>
              </div>
            </div>
          </div>
          <div modal-backdrop='' className='bg-gray-100 bg-opacity-50 dark:bg-opacity-50 fixed inset-0 z-40'></div>
        </div>
      )}

      {this.state.popup && (
        <div className='flex justify-center'>
          <div
            tabIndex='-1'
            className='fixed top-0 left-0 right-0 z-50 p-4 overflow-x-hidden overflow-y-auto md:inset-0 h-[calc(100%-1rem)] md:h-full'
          >
            <div className='relative w-full h-full max-w-md md:h-auto md:w-auto m-auto mt-40'>
              <div className='relative bg-gray-50 rounded-lg shadow dark:bg-gray-700'>
                <div className='p-6 text-center'>
                  <svg
                    aria-hidden='true'
                    className='mx-auto mb-4 text-gray-400 w-14 h-14 dark:text-gray-200'
                    fill='none'
                    stroke='currentColor'
                    viewBox='0 0 24 24'
                    xmlns='http://www.w3.org/2000/svg'
                  >
                    <path
                      strokeLinecap='round'
                      strokeLinejoin='round'
                      strokeWidth='2'
                      d='M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'
                    ></path>
                  </svg>
                  <h3 className='mb-5 text-lg font-normal text-gray-500 dark:text-gray-400'>
                    {this.state.popup?.message}
                  </h3>
                  {this.state.popup.confirm && (
                    <button
                      onClick={this.popup.confirm.bind(this)}
                      type='button'
                      className='text-white bg-blue-600 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 dark:focus:ring-blue-800 font-medium rounded-lg text-sm inline-flex items-center px-5 py-2.5 text-center mr-2'
                    >
                      {this.i18n('popup.confirm')}
                    </button>
                  )}
                  <button
                    onClick={this.popup.exit.bind(this)}
                    type='button'
                    className='text-gray-500 bg-gray-50 hover:bg-gray-100 focus:ring-4 focus:outline-none focus:ring-gray-200 rounded-lg border border-gray-200 text-sm font-medium px-5 py-2.5 hover:text-gray-900 focus:z-10 dark:bg-gray-700 dark:text-gray-300 dark:border-gray-500 dark:hover:text-white dark:hover:bg-gray-600 dark:focus:ring-gray-600'
                  >
                    {this.i18n('popup.exit')}
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div modal-backdrop='' className={this.popup.className()}></div>
        </div>
      )}
    </>
  )
}
