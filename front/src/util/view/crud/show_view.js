import ApplicationView from '@/util/view/application_view'

export default class ShowView extends ApplicationView {
  show = (_) => this.request(this.Helper.Next.Router.asPath)

  init = this.show

  name = 'show'

  template = (_) => (
    <div className='w-full'>
      <h4 className='text-2xl font-bold dark:text-white mt-4 mb-4'>{this.i18n('title')}</h4>

      {this.attributes(this.ApplicationComponent.Output).map((attribute, index) => (
        <attribute.Component key={index} model={this.model()} attribute={attribute} parent={this} />
      ))}

      <div className='mt-4'>
        {this.paths().map((path, index) =>
          path.method === 'get' ? (
            <this.Helper.Tailwind.Link.Default key={index} href={path.url}>
              {path.title}
            </this.Helper.Tailwind.Link.Default>
          ) : (
            <this.Helper.Tailwind.Button.Link
              key={index}
              type='button'
              onClick={this.onClickRequest.bind(this, { path })}
            >
              {path.title}
            </this.Helper.Tailwind.Button.Link>
          ),
        )}
      </div>
    </div>
  )
}
