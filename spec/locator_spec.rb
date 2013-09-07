require 'spec_helper'

describe Ruremai::Locator do
  describe '.ordered_locators' do
    context 'locale: en' do
      subject { Ruremai::Locator.ordered_locators(['en']).first }

      its(:locale) { should == 'en' }
    end

    context 'locale: :en' do
      subject { Ruremai::Locator.ordered_locators([:en]).first }

      its(:locale) { should == 'en' }
    end

    context 'locale: ja' do
      subject { Ruremai::Locator.ordered_locators(['ja']).first }

      its(:locale) { should == 'ja' }
    end
  end
end
