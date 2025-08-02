import ApplicationFilter from './application_filter'
import BigIntFilter from './bigint_filter'
import UUIDFilter from './uuid_filter'
import StringFilter from './string_filter'

export default class ReferenceFilter extends ApplicationFilter {
  bigintAttribute = (_) => ({
    ...this.props.attribute,
    name: `${this.props.attribute.name}_${this.props.attribute.reference.key}`,
    title: `${this.props.attribute.title} ${this.props.attribute.reference.key.toUpperCase()}`,
  })
  stringAttribute = (_) => ({
    ...this.props.attribute,
    name: `${this.props.attribute.name}_${this.props.attribute.reference.name}`,
    title: `${this.props.attribute.title} ${this.props.attribute.reference.title}`,
  })

  render = (_) => (
    <>
      {(this.props.attribute.reference.key === 'id' && (
        <BigIntFilter attribute={this.bigintAttribute()} parent={this.props.parent} />
      )) || <UUIDFilter attribute={this.bigintAttribute()} parent={this.props.parent} />}
      <StringFilter attribute={this.stringAttribute()} parent={this.props.parent} />
    </>
  )
}
