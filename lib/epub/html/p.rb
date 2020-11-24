module EPUB
	module HTML
		class P < Generic
			def initialize(attrs)
				super('p', attrs)
			end
			
			def render
				output = strip(super.join(''))
				# it looks like this is roughly one a para, not per chapter
				unless output.match('^( | )*`.*`$') # skip code lines
					output.gsub!(/(\S[.!?])\s+/, "\\1\n") # one sentence per line
				end
				
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
				when '{:.para_indented}', '{:.text}', '{:.unnumlist}',
					'{:.unnumlist1}', nil
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
