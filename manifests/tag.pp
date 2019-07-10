# Allow custom tags via a define
define datadog_agent::tag(
  $tag_name = $name,
  $lookup_fact = false,
){
  include datadog_agent

  if $::datadog_agent::agent6_enable {
    $dst = '/etc/datadog-agent/datadog.yaml'
  } else {
    $dst = '/etc/dd-agent/datadog.conf'
  }

  if $lookup_fact{
    $value = getvar($tag_name)

    if is_array($value){
      $tags = prefix($value, "${tag_name}:")
      datadog_agent::tag{$tags: }
    } else {
      if $value {
        concat::fragment{ "datadog tag ${tag_name}:${value}":
          target  => $dst,
          content => "${tag_name}:${value}, ",
          order   => '03',
        }
      }
    }
  } else {
    concat::fragment{ "datadog tag ${tag_name}":
      target  => $dst,
      content => "${tag_name}, ",
      order   => '03',
    }
  }

}
