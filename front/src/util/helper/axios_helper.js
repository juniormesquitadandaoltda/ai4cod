const Axios = require('axios').create({
  baseURL: '/data',
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
  maxRedirects: 0,
})

export default Axios
