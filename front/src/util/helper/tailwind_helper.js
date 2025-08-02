import Link from 'next/link'

const Tailwind = {
  Link: {
    Default: ({ href, className, children, target, onClick }) =>
      ({
        [false]: (
          <Link
            href={href}
            className={className || 'font-medium text-blue-600 dark:text-blue-500 hover:underline mr-2'}
          >
            {children}
          </Link>
        ),
        [true]: (
          <a
            href={href}
            target={target}
            onClick={onClick}
            className={className || 'font-medium text-blue-600 dark:text-blue-500 hover:underline mr-2'}
          >
            {children}
          </a>
        ),
      })[!!target],
    Action: {
      Default: ({ href, className, children, target }) =>
        ({
          [false]: (
            <Link
              href={href}
              className={className || 'block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white'}
            >
              {children}
            </Link>
          ),
          [true]: (
            <a
              href={href}
              target={target}
              className={className || 'block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white'}
            >
              {children}
            </a>
          ),
        })[!!target],
      Request: ({ href, onClick, children }) => (
        <a
          href={href}
          className='block py-2 px-4 hover:bg-gray-100 dark:hover:bg-gray-600 dark:hover:text-white'
          onClick={onClick}
        >
          {children}
        </a>
      ),
    },
  },
  Button: {
    Default: ({ type, className, onClick, children }) => (
      <button
        type={type}
        className={
          className ||
          'text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 mr-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800'
        }
        onClick={onClick}
      >
        {children}
      </button>
    ),
    Link: ({ type, onClick, children }) => (
      <button
        type={type}
        className='font-medium text-blue-600 dark:text-blue-500 hover:underline pr-2'
        onClick={onClick}
      >
        {children}
      </button>
    ),
  },
}

export default Tailwind
