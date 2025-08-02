import { Component } from 'react'
import ApplicationLocale from '../locale/application_locale'
import Next from '../helper/next_helper'
import Tailwind from '../helper/tailwind_helper'
import Axios from '../helper/axios_helper'

export default class ApplicationBase extends Component {
  Helper = { Next, Tailwind, Axios }
  I18n = {
    t: (locale, path, options) => {
      let value = ''

      try {
        value = path.split('.').reduce((result, key) => result[key], ApplicationLocale[locale])
        value = value.replace(/\${(.*)}/g, (a, b, c) => options[b])
      } catch {}

      return value
    },
  }

  // _request = async (params, successState, failState) => {
  //   this.layout().setState({loading: true})
  //   let data = null
  //   let status = null

  //   try {
  //     let {data, status} = await this.Helper.Axios(params)
  //     data = successState(data)
  //   } catch (error) {
  //     let {data, status} = error.response

  //     if (data.alert)
  //       this.layout().popup.new({
  //         message: data.alert,
  //         exit: _ => {
  //           const redirect = data.redirect

  //           if (redirect)
  //             this.Helper.Next.Router.push(redirect)
  //         }
  //       })

  //     data = failState(data)
  //   }

  //   this.setState({response: {...this.state.response, data}, status, currentTime: new Date().getTime()})
  // }
}
