# Documented class
class puppethack (
  $key = 'value',
  $otherkey = 'othervalue', 
) { 
  package {'puppet':
    ensure => present,
  }

}
