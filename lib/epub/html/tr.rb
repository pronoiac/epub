module EPUB
	module HTML
		class TR < Generic
			def initialize(attrs)
				super('tr', attrs)
			end

			def render
				output = strip(super.join(''))
				output = ["#{output} |\n"]
				output
			end
		end
	end
end
