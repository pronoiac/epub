module EPUB
	module HTML
		class P < Generic
			def initialize(attrs)
				super('p', attrs)
			end
			
			def render
				output = strip(super.join(''))
				
				if output.length == 0
					return []
				end
				
				p_class = attributes[1]
				case p_class
				when '{:.textfl}'
					# after header. add extra line before.
					output = ["\n#{output}\n"]
				when '{:.quote}'
					output = ["> #{output}\n"]
				when '{:.bulllist}'
					output = ["* #{output}\n"]
				when '{:.para_indented}', '{:.text}', nil
					# passthrough
					output = ["#{output}\n"]
				else
					output = ["#{output}\n!!!(p) #{p_class}\n"]
				end
				output << "\n"
				
				output
				
			end
		end
	end
end
