root = File.expand_path('../../../hermes', __FILE__)
build_dir = root + '/build/Release'

plist = "#{build_dir}/Hermes.app/Contents/Info"
version = `defaults read #{plist} CFBundleShortVersionString`.chomp

index = File.expand_path('../../index.html', __FILE__)
s = File.read(index)
s = s.gsub(/(class=.download. href.*Hermes-)[\d\.]+(\.zip)/, "\\1#{version}\\2")
File.open(index, 'wb') { |f| f << s }

versions = File.expand_path('../../versions.xml', __FILE__)
new_xml = File.read(build_dir + '/versions.xml').gsub("\t", '  ')

s = File.read(versions)
if !s.match(/Version #{version}/)
  s = s.gsub(/(<\/language>.*\n)/, '\1' + new_xml + "\n")
  File.open(versions, 'wb') { |f| f << s }
end

s = File.read(root + '/CHANGELOG.md')
require 'bluecloth'
File.open('changelog.html', 'wb') { |f| f << BlueCloth.new(s).to_html }
