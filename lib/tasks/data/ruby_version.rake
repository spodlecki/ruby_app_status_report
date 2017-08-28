namespace :ruby_version do
  task download: [:environment] do
    base_ruby_url = 'https://www.ruby-lang.org'
    ruby_url      = 'https://www.ruby-lang.org/en/downloads/releases/'
    require 'nokogiri'

    doc           = Nokogiri::HTML(open(ruby_url))
    tr_releases   = doc.css('table.release-list tr')

    tr_releases.each do |tr_release|
      eles = tr_release.children.select {|x| x.is_a?(Nokogiri::XML::Element) }
      next if eles.count != 3 || eles.first.name == 'th'

      version   = eles[0].text.downcase.delete('ruby').strip
      date      = Date.parse(eles[1].text)
      notes_url = eles[2].css('a').attribute('href').value

      model           = RubyVersion.find_or_initialize_by(version: version)
      model.released  = date
      model.notes_url = [base_ruby_url, notes_url].join
      model.save
    end
  end
end
