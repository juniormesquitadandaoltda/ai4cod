import ApplicationController from './application_controller'

export default class SessionController extends ApplicationController {
  get view() {
    return this.View.Session[this.action]
  }
}
