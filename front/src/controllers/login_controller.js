import ApplicationController from './application_controller'

export default class LoginController extends ApplicationController {
  get view() {
    return this.View.Login[this.action]
  }
}
