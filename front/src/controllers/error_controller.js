import ApplicationController from './application_controller'

export default class ErrorController extends ApplicationController {
  get view() {
    return this.View.Error[this.action]
  }
}
