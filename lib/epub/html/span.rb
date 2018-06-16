module EPUB
	module HTML
		class SPAN < Generic
			def initialize(attrs)
				super('span', attrs)
			end

			def render
				output = strip(super.join(''))

				if output.length == 0
					return []
				end

				span_class = attributes[0]
				case span_class # class
				when '{:.italic}'
					output = ["*#{output}*"]
				when '{:.bold}'
					output = ["**#{output}**"]
				when '{:.inlinecode}'
					output = ["`#{output}`"]
				when nil
					output = ["#{output}"]
				else
					if span_class =~ /\#p\d+/
						# eat apparent paragraph anchors
						output = ["#{output}"]
					else
						# not handled yet: smallcaps, fignum, hiddenClass
						output = ["#{output}\n!!!(span) #{span_class}\n"]
					end
				end

				output
			end
		end
	end
end
