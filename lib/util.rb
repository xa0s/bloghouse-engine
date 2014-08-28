require 'nutils/data_sources'

include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo

class NilClass
  def each
    nil
  end
end
