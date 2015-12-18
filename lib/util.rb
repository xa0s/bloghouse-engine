require 'nutils/data_sources'

include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::XMLSitemap

class NilClass
  def each
    nil
  end
end
