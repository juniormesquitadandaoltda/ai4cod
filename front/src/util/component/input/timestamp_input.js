import ApplicationInput from './application_input'

export default class TimestampInput extends ApplicationInput {
  defaultValue = (_) => {
    let value = this.value()

    if (!!value) {
      const d = value
        .replace(/[\s:-]/g, '_')
        .replace('__', '_-')
        .split('_')
      value = `${d[2]}/${d[1]}/${d[0]} ${d[3]}:${d[4]}:${d[5]}`
    }

    return value
  }

  parse = (event) => {
    const value = event.target.value

    if (value.includes('-')) return ''

    const d = value.replaceAll('-', '0').replace(' ', '/').replaceAll(':', '/').split('/')

    return `${d[2]}-${d[1]}-${d[0]} ${d[3]}:${d[4]}:${d[5]}`
  }

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>
      <this.Helper.Next.InputMask
        id={this.name()}
        onChange={this.onChange.bind(this)}
        mask={this.mask()}
        maskPlaceholder='-'
        alwaysShowMask={false}
        defaultValue={this.defaultValue()}
        type='text'
        className='bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
      />
      <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error()}</span>
    </div>
  )
}
