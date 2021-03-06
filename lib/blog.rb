include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Tagging

require "erb" 
include ERB::Util

class Nanoc::Item

    def self.construct(site, raw_content_or_raw_filename, attributes, identifier, params = nil)
        item = Nanoc::Item.new(raw_content_or_raw_filename, attributes, identifier, params)
        item.site = site
        item
    end

    def catalogs
        @catalogs
    end

    def catalogs=(items)
        @catalogs = items
        @attributes[:pagers] = items ? items.map { |i| i[:pager] } : []
    end

    def parse_i18n
    	langs = $pref[:languages].select do |lang|
    		self.identifier.include? "/#{lang}/"
    	end

    	case langs.size
    	when 0
    		{ :id => self.identifier, :lang => $pref[:languages][0] }
    	when 1
    		{ :id => self.identifier =~ %r{^(/.*/)#{langs[0]}/$} ? $~[1] : self.identifier, :lang => langs[0] }
    	else
    		abort "Error: the language of item #{self.identifier} is ambiguous!"
    	end
    end

    def i18n
        @i18n_ ||= parse_i18n
    end

    def time(attr)
       t = attribute_to_time(@attributes[attr])
       t.is_a?(Time) ? t : nil
    end

    def url
    	$pref[:base_url] + self.path
    end
end

def articles_by_lang(lang)
    blk = lambda { articles.select { |item| item.i18n[:lang] == lang and !item[:sandbox] } }
    
    blk.call
end

def sorted_articles_by_lang(lang)
    blk = lambda do
        articles_by_lang(lang).sort_by { |a| attribute_to_time(a[:created_at]) }.reverse
    end

    blk.call
end

def translations
    blk = lambda do
        trans = Hash.new{|h,k| h[k] = {}}
        @items.each do |x|
            if x.i18n.any?
                trans[x.i18n[:id]][x.i18n[:lang]] = x
            end
        end
        trans
    end

    if @items.frozen?
        @translations_ ||= blk.call
    else
        blk.call
    end
end

def versions_of(item)
	translations[item.i18n[:id]] || {}
end

def translations_of(item)
    ts = translations[item.i18n[:id]]
    if ts
        ts.select { |k,v| v != item }
    else
        {}
    end
end

def tags_for(item)
    if item[:tags].nil? || item[:tags].empty?
        []
    else
        item[:tags]
    end
end

def tags
    blk = lambda do
        tgs = Set.new
        articles.each do |article|
          tags_for(article).each { |t| tgs.add(t.downcase) }
        end
        tgs
    end
    if @items.frozen?
        @tags_ ||= blk.call
    else
        blk.call
    end
end

def sorted_articles_by_lang_and_tag(lang, tag)
    sorted_articles_by_lang(lang).select{ |i| tags_for(i).include? tag }
end

def timeline_of(items)
    timeline = Hash.new{|h,k| h[k] = []}
    
    items.reverse.each do |article|
        time = attribute_to_time(article[:created_at])
        timeline[time.year] << article
    end

    timeline
end
