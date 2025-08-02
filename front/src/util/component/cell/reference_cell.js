import ApplicationCell from './application_cell'

export default class ReferenceCell extends ApplicationCell {
  defaultValue = (_) => this.value()[this.props.attribute.reference.name]

  show = (_) => this.props.model[this.name()].paths[0]?.url

  render = (_) => (
    <td className='px-5 py-2.5 text-sm border-b dark:border-gray-700'>
      {(!this.show() && this.defaultValue()) || (
        <this.Helper.Tailwind.Link.Default href={this.show()} target='_blank'>
          {this.defaultValue()}
        </this.Helper.Tailwind.Link.Default>
      )}
    </td>
  )
}
