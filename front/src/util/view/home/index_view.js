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

  telegramURL = (_) => 'https://t.me/ai4cod'
  linkedinURL = (_) => 'https://www.linkedin.com/company/ai4cod'
  tasksCount = (_) => this.state.response?.count

  template = (_) => (
    <div key={this.state.currentTime} className='w-full text-center'>
      <h1 className='mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl dark:text-white mt-20'>
        {this.i18n('title')}{' '}
        <mark className='px-2 text-white bg-blue-600 rounded dark:bg-blue-500'>{this.i18n('title_mark')}</mark>
      </h1>

      <p className='text-lg font-normal text-gray-500 lg:text-xl dark:text-gray-400 mt-10'>
        {/*
        <this.Helper.Tailwind.Link.Default href={this.telegramURL()} className='underline mr-2' target='_blank'>
          Facebook
        </this.Helper.Tailwind.Link.Default>
        <this.Helper.Tailwind.Link.Default href={this.linkedinURL()} className='underline mr-2' target='_blank'>
          LinkedIn
        </this.Helper.Tailwind.Link.Default>
        <this.Helper.Tailwind.Link.Default href={this.telegramURL()} className='underline mr-2' target='_blank'>
          Telegram
        </this.Helper.Tailwind.Link.Default>
        <this.Helper.Tailwind.Link.Default href={this.telegramURL()} className='underline mr-2' target='_blank'>
          WhatsApp
        </this.Helper.Tailwind.Link.Default>
        <this.Helper.Tailwind.Link.Default href={this.linkedinURL()} className='underline' target='_blank'>
          X
        </this.Helper.Tailwind.Link.Default>
 */}
      </p>

      <h6 className='mb-4 text-4xl font-extrabold leading-none tracking-tight text-gray-900 md:text-5xl lg:text-6xl dark:text-white mt-10'>
        +<mark className='px-2 text-white bg-blue-600 rounded dark:bg-blue-500'>{this.tasksCount()}</mark> tarefas
        gerenciadas
      </h6>

      <p className='text-lg font-normal text-gray-500 lg:text-xl dark:text-gray-400 mt-10'>
        <this.Helper.Tailwind.Link.Default href='/login/session/new' className='underline'>
          {this.i18n('click')}
        </this.Helper.Tailwind.Link.Default>{' '}
        {this.i18n('instruction')}
      </p>
    </div>
  )
}
