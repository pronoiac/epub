module EPUB
	module HTML
		class TABLE < Generic
			def initialize(attrs)
				super('table', attrs)
			end

			def render
				output = super.join('')
				str = text
				
				byebug if blank?(str)
				if !(blank?(str))
					# add header
					output = ["\n!!!(table)\n\n| []() | | | | | | | | | |\n|---|---|---|---|---|---|---|---|---|---|\n", output]
				end
				output
			end
		end
	end
end
