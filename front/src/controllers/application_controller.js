import ApplicationUtil from '@/util/application_util'

export default class ApplicationController extends ApplicationUtil {
  state = {
    pages: [],
  }

  get view() {
    return this.View.CRUD[this.action]
  }

  render = (_) => (
    <this.Layout.Application title='AI for Code .COM' pages={this.state.pages}>
      <this.view controller={this} />
    </this.Layout.Application>
  )
}
