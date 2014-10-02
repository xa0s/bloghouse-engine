require 'yaml'

$pref = Hash[ YAML.load_file('../content/preferences.yml').map{|(k,v)| [k.to_sym,v]} ].freeze
