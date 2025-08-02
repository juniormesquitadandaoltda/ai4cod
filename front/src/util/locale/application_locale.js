const ApplicationLocale = ['en', 'pt-BR'].reduce(
  (object, child) => ({ ...object, [child]: require(`./${child}.yml`) }),
  {},
)

export default ApplicationLocale
