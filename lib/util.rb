require 'nutils/data_sources'

include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::XMLSitemap

class NilClass
  def each
    nil
  end
end

def category_of(item)
	if item.identifier =~ %r{^/posts/} || item.identifier =~ %r{^/blog/}
		'blog'
	else
		'general'
	end
end

def title_of(item)
	title = item[:title]
	category = tr(category_of(item), :scope => :category)

	if title
		"#{title} | #{category}"
	else
		category
	end
end
