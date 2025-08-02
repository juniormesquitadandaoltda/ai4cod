import ApplicationFilter from './application_filter'

export default class SortFilter extends ApplicationFilter {
  title = (_) => {
    let entity = ''
    const name =
      this.props.attribute.type === 'reference'
        ? `${this.props.attribute.name}_${this.props.attribute.reference.name}`
        : this.props.attribute.name

    if (name === this.props.parent.state.filter.sort)
      entity = this.props.parent.state.filter.order === 'asc' ? <>&#9652;</> : <>&#9662;</>

    return (
      <>
        {this.props.attribute.title} {entity}
      </>
    )
  }

  onClick = (_) => {
    let order = 'asc'
    const name =
      this.props.attribute.type === 'reference'
        ? `${this.props.attribute.name}_${this.props.attribute.reference.name}`
        : this.props.attribute.name

    if (name === this.props.parent.state.filter.sort)
      order = this.props.parent.state.filter.order === 'asc' ? 'desc' : 'asc'

    this.props.parent.updateFilter({ sort: name, order: order })
  }

  render = (_) => <button onClick={this.onClick.bind(this)}>{this.title.bind(this)()}</button>
}
