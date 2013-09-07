require 'spec_helper'
require 'pp'

describe Ruremai do
  describe '.ordered_locators' do
    context 'locale: en' do
      subject { Ruremai.ordered_locators('en').first }

      its(:locale) { should == 'en' }
    end

    context 'locale: :en' do
      subject { Ruremai.ordered_locators(:en).first }

      its(:locale) { should == 'en' }
    end

    context 'locale: ja' do
      subject { Ruremai.ordered_locators('ja').first }

      its(:locale) { should == 'ja' }
    end
  end

  #describe '.locate' do
  #  context 'primary_locale: en' do
  #    describe 'PP::ObjectMixin#pretty_print_cycle' do
  #      let(:locale)  { :en }
  #      let(:methods) { Kernel.methods(false) }

  #      specify do
  #        methods.each do |m|
  #          Ruremai.launch(Kernel.method(m), locale)
  #        end
  #      end
  #    end
  #  end
  #end
end
