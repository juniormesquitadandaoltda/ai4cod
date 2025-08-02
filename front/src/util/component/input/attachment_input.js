import ApplicationInput from './application_input'

export default class TextInput extends ApplicationInput {
  title = (_) => `${this.props.attribute.title} (${this.value()?.length || 0})`

  size = (file) => {
    const bytes = file.size

    if (bytes === 0) return '0 Bytes'

    const k = 1000
    const sizes = ['Bytes', 'KB', 'MB', 'GB']
    const i = Math.floor(Math.log(bytes) / Math.log(k))

    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i]
  }

  base64 = (file) =>
    new Promise((resolve, reject) => {
      const reader = new FileReader()
      reader.readAsDataURL(file)
      reader.onload = (_) => resolve(reader.result.split(',')[1])
      reader.onerror = (error) => reject(error)
    })

  onChange = async (event) => {
    let value = this.parse(event)

    value =
      value.length === 0
        ? null
        : await Promise.all(
            value.map(async (file) => {
              file.filename = file.name
              file.base64 = await this.base64(file)
              file.url = URL.createObjectURL(file)

              return file
            }),
          )

    this.props.parent.updateModel({ [this.name()]: value })
  }

  parse = (event) => {
    const newFiles = Array.from(event.target.files)
    const existingFiles = this.value() || []

    const uniqueFiles = newFiles.concat(existingFiles).filter((file, index, array) => {
      return array.findIndex((f) => f.name === file.name && f.size === file.size) === index
    })

    return uniqueFiles
      .sort((fileA, fileB) => fileA.name.toLowerCase().localeCompare(fileB.name.toLowerCase()))
      .filter((f) => f.size <= 1000 ** 2)
  }

  remove = (file) => {
    const dataTransfer = new DataTransfer()

    this.value().forEach((current) => {
      if (current.name !== file.name || current.size !== file.size) {
        dataTransfer.items.add(current)
      }
    })

    this.props.parent.updateModel({ [this.name()]: Array.from(dataTransfer.files) })
  }

  fileError = (file) => file.errors && Object.values(file.errors)[0]

  error = (_) => (this.props.parent.state.response.error || {}).blob

  render = (_) => (
    <div className='mt-6 p-4 pt-2 border border-gray-200 rounded dark:border-gray-700'>
      <label htmlFor={this.name()} className='block mb-2 text-sm font-medium text-gray-900 dark:text-white'>
        {this.title()}
      </label>
      <div className='relative'>
        <input
          type='file'
          multiple
          id={this.name()}
          onChange={this.onChange.bind(this)}
          readOnly={this.readOnly()}
          className='hidden'
        />
        {this.value()?.length > 0 && (
          <div className='mt-4'>
            <ul className='divide-y divide-gray-200 dark:divide-gray-700'>
              {this.value().map((file, index) => (
                <li key={index} className='py-2 flex items-center justify-between'>
                  <div className='flex items-center'>
                    <svg
                      className='w-5 h-5 text-gray-500 dark:text-gray-400 mr-2'
                      fill='none'
                      stroke='currentColor'
                      viewBox='0 0 24 24'
                      xmlns='http://www.w3.org/2000/svg'
                    >
                      <path
                        strokeLinecap='round'
                        strokeLinejoin='round'
                        strokeWidth='2'
                        d='M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z'
                      ></path>
                    </svg>
                    <div>
                      <this.Helper.Tailwind.Link.Default
                        href={file.url}
                        className='text-sm font-medium text-blue-600 dark:text-blue-500 hover:underline'
                        target='_blank'
                      >
                        {file.name}
                      </this.Helper.Tailwind.Link.Default>
                      <p className='text-xs text-gray-500 dark:text-gray-400'>{this.size(file)}</p>
                    </div>
                  </div>
                  {(this.fileError(file) && (
                    <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>
                      {this.fileError(file)}
                    </span>
                  )) || (
                    <button
                      type='button'
                      onClick={() => this.remove(file)}
                      className='text-red-600 hover:text-red-800 dark:text-red-400 dark:hover:text-red-300'
                    >
                      <svg
                        className='w-5 h-5'
                        fill='none'
                        stroke='currentColor'
                        viewBox='0 0 24 24'
                        xmlns='http://www.w3.org/2000/svg'
                      >
                        <path
                          strokeLinecap='round'
                          strokeLinejoin='round'
                          strokeWidth='2'
                          d='M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16'
                        ></path>
                      </svg>
                    </button>
                  )}
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
      <label
        htmlFor={this.name()}
        className='flex justify-center border-2 bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg hover:ring-blue-500 hover:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:hover:ring-blue-500 dark:hover:border-blue-500'
      >
        <svg
          className='w-5 h-5 mr-2'
          fill='none'
          stroke='currentColor'
          viewBox='0 0 24 24'
          xmlns='http://www.w3.org/2000/svg'
        >
          <path
            strokeLinecap='round'
            strokeLinejoin='round'
            strokeWidth='2'
            d='M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12'
          ></path>
        </svg>
      </label>
      <span className='block mt-2 -mb-2 text-sm text-red-600 dark:text-red-500'>{this.error()}</span>
    </div>
  )
}
