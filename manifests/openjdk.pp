# @summary
#   Private class for installing and configure openjdk
#
# @api private
#
class java::openjdk {

  require java

  include java::openjdk::install
  include java::openjdk::alternatives

  Package <| tag == 'openjdk' |>
  -> Class['java::openjdk::alternatives']
}
