module EPUB
	module HTML
		class TD < Generic
			def initialize(attrs)
				super('td', attrs)
			end
			
			def render
				output = strip(super.join(''))
				output = "| #{output} "
				[output]
			end
		end
	end
end
