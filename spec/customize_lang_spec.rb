require 'spec_helper'

if property.key?('redmine_customize_language')
  describe file(property['redmine_home'] + '/config/locales/' + property['redmine_lang'] + '.yml') do
    customize_langs = property['redmine_customize_language'][property['redmine_lang']]
    customize_langs.each do |k, v|
      it { should contain "#{k}: #{v}" }
    end
  end
end
