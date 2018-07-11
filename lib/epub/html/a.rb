module EPUB
	module HTML
		class A < Generic
			
			def initialize(attrs)
				super('a', attrs)
			end
			
			def href
				h = get_attr('href')
				
				if blank?(h)
					return "#"
				end
				
				h
			end
			
			def render
				string = strip(super.join(''))
				
				if blank?(string) 
					string = " "
				end
				
				output = []
				
				unless href.empty? or string == " "
					output << "[#{string}](#{href})"
				end
				
				# attributes.each do |attr|
				# 	output << attr
				# end
				
				[output.join('')]
			end
		end
	end
end
