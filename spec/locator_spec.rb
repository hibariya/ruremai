require 'spec_helper'
require 'webmock'

describe Ruremai::Locator do
  include WebMock::API

  describe '.locate' do
    let(:locales) { %w(en) }

    let(:uris) {
      {
        not_found: URI.parse('http://example.com/not_found'),
        accepted:  URI.parse('http://example.com/accepted'),
        ok:        URI.parse('http://example.com/ok')
      }
    }

    before do
      @locator = double(:locator).tap {|l|
        l.stub(:locale)   { 'en' }
        l.stub(:base_uri) { URI('http://example.com') }
      }

      stub_request(:head, uris[:not_found].to_s).to_return(status: 404)
      stub_request(:head, uris[:accepted].to_s).to_return(status: 202)
      stub_request(:head, uris[:ok].to_s).to_return(status: 200)

      Ruremai::Locator.stub(:locators) { [@locator] }
    end

    context 'got [202, 200]' do
      before do
        @locator.stub(:candidates) { uris.values_at(:accepted, :ok) }
      end

      specify 'return the uri if got 200' do
        Ruremai::Locator.locate(double(:method), locales).should == uris[:ok]
      end
    end

    context 'got [202, 202]' do
      before do
        @locator.stub(:candidates) { [uris[:accepted]] * 2 }
      end

      specify 'return the uri if got 202 only' do
        Ruremai::Locator.locate(double(:method), locales).should == uris[:accepted]
      end
    end

    context 'got [404, 202]' do
      before do
        @locator.stub(:candidates) { uris.values_at(:not_found, :accepted) }
      end

      specify 'pass the uri if got 404' do
        Ruremai::Locator.locate(double(:method), locales).should == uris[:accepted]
      end
    end
  end

  describe '.locators_for' do
    subject { Ruremai::Locator.send(:locators_for, locales).first }

    context 'locale: en' do
      let(:locales) { ['en'] }

      its(:locale) { should == 'en' }
    end

    context 'locale: :en' do
      let(:locales) { [:en] }

      its(:locale) { should == 'en' }
    end

    context 'locale: ja' do
      let(:locales) { ['ja'] }

      its(:locale) { should == 'ja' }
    end
  end
end
