import ApplicationUtil from '@/util/application_util'

export default class ChatController extends ApplicationUtil {
  state = {
    pages: [],
  }

  get view() {
    return this.View.Chat[this.action]
  }

  render = (_) => (
    <this.view controller={this} />
  )
}
