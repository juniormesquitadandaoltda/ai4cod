import '@/util/helper/sentry_helper'
import ApplicationBase from '@/util/base/application_base'
import '@/styles/globals.css'

export default class App extends ApplicationBase {
  render = (_) => <this.props.Component {...this.props.pageProps} />
}
