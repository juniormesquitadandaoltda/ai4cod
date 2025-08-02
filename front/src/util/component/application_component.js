const Cell = [
  'bigint',
  'string',
  'text',
  'date',
  'time',
  'datetime',
  'timestamp',
  'boolean',
  'enum',
  'field_enum',
  'json',
  'array',
  'reference',
  'integer',
  'decimal',
  'uuid',
  'byte',
].reduce(
  (object, child) => ({
    ...object,
    [child]: require(`@/util/component/cell/${child}_cell`).default,
  }),
  {},
)

const Filter = [
  'bigint',
  'string',
  'text',
  'date',
  'time',
  'datetime',
  'timestamp',
  'boolean',
  'enum',
  'field_enum',
  'json',
  'array',
  'reference',
  'integer',
  'decimal',
  'uuid',
  'sort',
  'pagination',
].reduce(
  (object, child) => ({
    ...object,
    [child]: require(`@/util/component/filter/${child}_filter`).default,
  }),
  {},
)

const Input = [
  'bigint',
  'string',
  'text',
  'date',
  'time',
  'datetime',
  'timestamp',
  'boolean',
  'enum',
  'field_enum',
  'json',
  'array',
  'reference',
  'integer',
  'decimal',
  'uuid',
  'secret',
  'attachment',
].reduce(
  (object, child) => ({
    ...object,
    [child]: require(`@/util/component/input/${child}_input`).default,
  }),
  {},
)

const Output = [
  'bigint',
  'string',
  'text',
  'date',
  'time',
  'datetime',
  'timestamp',
  'boolean',
  'enum',
  'field_enum',
  'json',
  'array',
  'reference',
  'integer',
  'decimal',
  'uuid',
  'secret',
  'byte',
].reduce(
  (object, child) => ({
    ...object,
    [child]: require(`@/util/component/output/${child}_output`).default,
  }),
  {},
)

const ApplicationComponent = {
  Cell,
  Filter,
  Input,
  Output,
}

export default ApplicationComponent
