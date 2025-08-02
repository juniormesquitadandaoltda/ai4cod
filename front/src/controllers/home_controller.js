import ApplicationController from './application_controller'

export default class HomeController extends ApplicationController {
  get view() {
    return this.View.Home[this.action]
  }
}
