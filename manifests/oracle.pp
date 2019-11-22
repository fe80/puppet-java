# @summary
#   Private class for installing and configure jdk oracle version
#
# @api private
#
class java::oracle {
  include java::oracle::repo
  include java::oracle::install
  include java::oracle::alternatives

  Apt::Source <| tag == 'oracle-jdk' |>
  -> Package <| tag == 'oracle-jdk' |>
  -> Class['java::oracle::alternatives']
}
