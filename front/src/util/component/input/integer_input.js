import ApplicationInput from './application_input'

export default class IntegerInput extends ApplicationInput {
  mask = (_) => {
    const masks = []
    const regex = /[0-9]/

    for (let i = 0; i < 18; i++) {
      masks.push(regex)
    }

    return masks
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
        maskPlaceholder={null}
        alwaysShowMask={false}
        defaultValue={this.defaultValue()}
        type='text'
        className='bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500'
      />
      <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error()}</span>
    </div>
  )
}
