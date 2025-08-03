import ApplicationBase from './base/application_base'
import ApplicationLayout from './layout/application_layout'

const View = {
  CRUD: ['Index', 'Show', 'New', 'Edit'].reduce(
    (object, child) => ({
      ...object,
      [child]: require(`./view/crud/${child.toLowerCase()}_view`).default,
    }),
    {},
  ),
  Login: ['New', 'Edit'].reduce(
    (object, child) => ({
      ...object,
      [child]: require(`./view/login/${child.toLowerCase()}_view`).default,
    }),
    {},
  ),
  Home: ['Index', 'PrivacyPolicy', 'UseTerms', 'CookiesPolicy'].reduce(
    (object, child) => ({
      ...object,
      [child]: require(
        `./view/home/${child
          .split(/\.?(?=[A-Z])/)
          .join('_')
          .toLowerCase()}_view`,
      ).default,
    }),
    {},
  ),
  Error: ['_404', '_500'].reduce(
    (object, child) => ({
      ...object,
      [child]: require(`./view/error/${child.toLowerCase()}_view`).default,
    }),
    {},
  ),
  Chat: ['Index'].reduce(
    (object, child) => ({
      ...object,
      [child]: require(`./view/chat/${child.toLowerCase()}_view`).default,
    }),
    {},
  ),
}

export default class ApplicationUtil extends ApplicationBase {
  View = View
  Layout = {
    Application: ApplicationLayout,
  }
}
