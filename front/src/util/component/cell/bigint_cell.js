import ApplicationCell from './application_cell'

export default class BigintCell extends ApplicationCell {
  show = (_) => this.props.model.paths.find((path) => path.name === 'show')?.url

  target = (_) => this.props.model.paths.find((path) => path.name === 'show')?.target

  render = (_) => (
    <td className='px-5 py-2.5 text-sm border-b dark:border-gray-700'>
      {(!this.show() && this.defaultValue()) || (
        <this.Helper.Tailwind.Link.Default href={this.show()} target={this.target()}>
          {this.defaultValue()}
        </this.Helper.Tailwind.Link.Default>
      )}
    </td>
  )
}
