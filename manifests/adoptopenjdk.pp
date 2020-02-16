# @summary Managed adoptopenjdk provider
#
# @example
#   include s_java::adoptopenjdk
class java::adoptopenjdk {
  assert_private()

  include java::adoptopenjdk::repo
  include java::adoptopenjdk::install
  include java::adoptopenjdk::alternatives

  Class[Java::Adoptopenjdk::Repo]
  -> Package <|tag == 'adoptopenjdk-jdk'|>
}
