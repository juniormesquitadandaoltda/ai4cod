import { Component } from 'react'

export default class ChatView extends Component {
  state = {
    ...this.state,
    messages: [],
    isCopying: false,
  }

  render = (_) => this.state.response && this.template()

  template = (_) => (
    <div key={this.state.currentTime} className='w-full'>
      { this.terminal() }
    </div>
  )

  terminal = (_) => (
    <div className='w-full h-screen bg-black text-green-400 font-mono flex flex-col select-text'>
      <h1 className='text-center text-4xl py-8 flex items-center justify-center gap-3'>
        <img src='/favicon.svg' alt='AI4COD' width='64' height='64' />
        AI for Code
      </h1>

      <div className='text-center text-lg mb-4 flex items-center justify-center gap-2'>
        <span className={`transition-colors duration-300 ${this.state.isCopying ? 'text-green-400' : 'text-gray-400'}`}>
          ai4cod.com
        </span>
        <button
          className='text-gray-500 hover:text-green-400 transition-colors cursor-pointer'
          onClick={() => this.copyToClipboard('ai4cod.com')}
          title='Copiar para área de transferência'
        >
          <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
            <path d="M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92s2.92-1.31 2.92-2.92S19.61 16.08 18 16.08z"/>
          </svg>
        </button>
      </div>

      <div className='px-4 overflow-y-auto'>
        {this.state.messages.map((msg, index) => (
          <div key={index} className='mb-4'>
            <div className='text-cyan-400'>Você: {msg.user}</div>
            <div className='text-green-400'>AI: {msg.ai}</div>
          </div>
        ))}
      </div>

      <div className='items-center w-full px-4 py-4'>
        <input
          ref={input => input && input.focus()}
          type='text'
          className='bg-transparent text-green-400 outline-none border-none font-mono w-full'
          placeholder='...'
          autoFocus
          onKeyPress={(e) => e.key === 'Enter' && this.handleMessage(e.target.value)}
        />
      </div>
    </div>
  )

  handleMessage = (text) => {
    if (!text.trim()) return

    const reversedText = text.split('').reverse().join('')

    const newMessage = {
      user: text,
      ai: reversedText
    }

    this.setState({
      messages: [...this.state.messages, newMessage]
    })

    document.querySelector('input').value = ''
  }

  copyToClipboard = (text) => {
    this.setState({ isCopying: true })

    if (navigator.clipboard) {
      navigator.clipboard.writeText(text).then(() => {
        console.log('Copiado: ' + text)
        setTimeout(() => {
          this.setState({ isCopying: false })
        }, 200)
      }).catch(err => {
        this.setState({ isCopying: false })
      })
    } else {
      const textArea = document.createElement('textarea')
      textArea.value = text
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand('copy')
      document.body.removeChild(textArea)
      setTimeout(() => {
        this.setState({ isCopying: false })
      }, 200)
    }
  }
}
