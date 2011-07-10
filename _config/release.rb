#!/usr/bin/env ruby
# Usage: ruby release.rb version path/to/versions.xml path/to/CHANGELOG.md

require 'rubygems'
require 'bluecloth'

version           = ARGV[0]
versions_xml_file = ARGV[1]
changelog         = ARGV[2]

html_root = File.expand_path '../..', __FILE__

index = File.join html_root, '/index.html'
s = File.read(index)
s = s.gsub(/(class=.download. href.*Hermes-)[\d\.]+(\.zip)/, "\\1#{version}\\2")
File.open(index, 'wb') { |f| f << s }

versions = File.expand_path('../../versions.xml', __FILE__)
new_xml = File.read(versions_xml_file).gsub("\t", '  ')

s = File.read(versions)
if !s.match(/Version #{version}/)
  s = s.gsub(/(<\/language>.*\n)/, '\1' + new_xml + "\n")
  File.open(versions, 'wb') { |f| f << s }
end

File.open(File.join(html_root, '/changelog.html'), 'wb') { |f|
  f << BlueCloth.new(File.read(changelog)).to_html
}
