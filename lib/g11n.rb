require 'i18n'

I18n.enforce_available_locales = true
I18n.load_path = Dir['../g11n/locales/*.yml', '../design/g11n/*.yml', '../content/g11n/*.yml']

def tr(*args)
	I18n.translate *args
end

def lc(*args)
	I18n.localize *args
end

class Localize 
	def self.to(lang)
		I18n.locale = lang
	end
end

class Nanoc::Compiler

    alias compile_rep_orig compile_rep

    def compile_rep(rep)

    	Localize.to rep.item.i18n[:lang] 

        compile_rep_orig(rep)
    end
end
