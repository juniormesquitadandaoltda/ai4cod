import IndexView from './index_view'

export default class TermsView extends IndexView {
  name = 'use_terms'

  template = (_) => (
    <div className='w-full flex flex-col justify-center items-center'>
      <div className='w-full md:w-5/12'>
        <iframe src={`/assets/docs/${this.name}.html`} style={{ width: '100%', height: '69vh' }} />
      </div>
    </div>
  )
}
