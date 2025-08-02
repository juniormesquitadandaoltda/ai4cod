import IndexView from './index_view'

export default class ReferenceView extends IndexView {
  name = 'reference'

  index = (_) =>
    this.request(
      {
        ...this.props.attribute.paths[0],
        params: this.state.filter,
      },
      (data) => this.setState({ tab: 'table' }),
    )

  title = (_) => this.props.attribute.title

  paths = (_) => [
    { title: this.i18n('close'), method: 'none' },
    { title: this.i18n('clear'), method: 'put' },
  ]

  current = (_) => (this.props.parent.model() || {})[this.props.attribute.name]

  models = (_) =>
    (this.state.response.models || []).map((model) => {
      model.paths =
        (!!model.id && model.id === this.current()?.id) || (!!model.uuid && model.uuid === this.current()?.uuid)
          ? [{ title: this.i18n('current') }]
          : [{ title: this.i18n('select') }]

      return model
    })

  init = (_) => this.updateFilter({}, this.index.bind(this))

  actions = (model, index) => (
    <td className='px-5 py-3 text-base border-b dark:border-gray-700'>
      <div>
        {model.paths.map((path, index) =>
          path.method === 'get' ? (
            <this.Helper.Tailwind.Link.Default key={index} href={path.url}>
              {path.title}
            </this.Helper.Tailwind.Link.Default>
          ) : (
            <this.Helper.Tailwind.Button.Link
              key={index}
              type='button'
              onClick={this.onClickRequest.bind(this, { path, model })}
            >
              {path.title}
            </this.Helper.Tailwind.Button.Link>
          ),
        )}
      </div>
    </td>
  )

  onClickRequest = ({ path, model }) => {
    if (path.method === 'none') {
      this.props.parent.updateModel()
    } else {
      this.props.parent.selectReference(this.props.attribute, model || null)
    }
  }
}
