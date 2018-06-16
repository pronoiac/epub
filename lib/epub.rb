require 'epub/version'
require 'epub/metadata'
require 'epub/manifest'
require 'epub/spine'
require 'epub/opf'
require 'epub/archive'
require 'epub/html'
require 'nokogiri'

module EPUB
	def self.parse(filename)
		EPUB.new(filename)
	end
	
	class EPUB
		
		def initialize(filename)
			@archive = Archive.new(filename)
			@mimetype = get_mimetype
			@rootfile = get_rootfile
			@rootpath = get_rootpath
			
			if (@mimetype != 'application/epub+zip')
				raise "Invalid mimetype: '#{@mimetype}' #{@mimetype != 'application/epub+zip'}"
			end
			
			@opf = OPF.new(@archive.get(@rootfile))
		end
		
		def metadata
			@opf.metadata
		end
		
		def manifest
			@opf.manifest
		end
		
		def spine
			@opf.spine
		end
		
		def title
			metadata.title
		end
		
		def identifier
			metadata.identifier
		end
		
		def language
			metadata.language
		end
		
		def description
			metadata.description
		end
		
		def image_items
			manifest.image_items
		end
		
		def html_items
			manifest.html_items
		end
		
		def spine_items
			spine.items.map { |item| html_items.select { |htmli| htmli[:id] == item[:idref] }.first }
		end
		
		def cover_filename
			if !@opf.metadata.cover_id
				return ''
			end
			
			record = manifest.get(@opf.metadata.cover_id)
			
			if !record
				return ''
			end
			
			record[:href]
		end
		
		def word_count
			count = 0
			
			spine_items.each do |html_item|
				next if html_item.nil?
				file = @archive.get(@rootpath + html_item[:href])
				
				if !file
					next
				end
				
				doc = HTML::Document.new
				parser = Nokogiri::XML::SAX::Parser.new(doc, "UTF-8")
				parser.parse(file)
				file.close
				
				count += doc.word_count
			end
			
			count
		end
		
		private 
		
		def get_mimetype
			file = @archive.get("mimetype") 
			mt = file.read
			file.close
			
			mt
		end
		
		def get_rootfile
			file = @archive.get("META-INF/container.xml") 
			
			doc = Nokogiri::XML(file)
			attr = doc.at_xpath('//container:rootfile/@full-path', container: 'urn:oasis:names:tc:opendocument:xmlns:container')

			file.close
			
			if attr.blank?
				return ''
			end
			
			attr.value
		end
		
		def get_rootpath
			idx = @rootfile.rindex('/')
			
			if !idx
				return ''
			end
			
			@rootfile.slice(0,idx+1)
		end
		
	end
end