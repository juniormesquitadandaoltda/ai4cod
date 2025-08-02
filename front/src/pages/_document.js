import App from './_app'
import { Html, Head, Main, NextScript } from 'next/document'
import Script from 'next/script'

export default class Document extends App {
  render = (_) => (
    <Html lang='en'>
      <Head>
        <link rel='preconnect' href='https://fonts.googleapis.com' />
        <link rel='preconnect' href='https://fonts.gstatic.com' crossOrigin='' />
        <link
          href='https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap'
          rel='stylesheet'
        />
      </Head>
      <body className='bg-gray-50 dark:bg-gray-900'>
        <Main />
        <NextScript />

        <Script id='theme' strategy='afterInteractive'>
          {`
            if (localStorage.getItem('dark') === 'true') {
              localStorage.setItem('dark', 'true')
              document.documentElement.classList.add('dark');
            } else {
              document.documentElement.classList.remove('dark')
            }
          `}
        </Script>
      </body>
    </Html>
  )
}
