require 'spec_helper'

describe Ruremai::Locator::Rurema do
  describe '#candidates' do
    PATH_VERSION_PART = (/\A1\./ =~ RUBY_VERSION ? RUBY_VERSION : RUBY_VERSION[/\A\d+\.\d+/] + ".0").freeze
    let(:locator) { Ruremai::Locator::Rurema.new(target) }

    subject { locator.candidates.map(&:to_s) }

    describe 'CamelCase method' do
      let(:target) { method(:Integer) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Kernel/m/Integer.html) }
    end

    describe 'query method' do
      let(:target) { nil.method(:nil?) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/NilClass/i/nil=3f.html) }
    end

    describe 'space ship operator' do
      let(:target) { 0.method(:<=>) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Integer/i/=3c=3d=3e.html) }
    end

    describe 'nested class' do
      let(:target) { Net::HTTP.method(:new) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Net=3a=3aHTTP/s/new.html) }
    end

    describe '`' do
      let(:target) { Kernel.method(:`) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Kernel/m/=60.html) }
    end

    describe 'infix operator method' do
      let(:target) { 1.method(:+) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Integer/i/=2b.html) }
    end

    describe 'prefix operator method' do
      let(:target) { 1.method(:+@) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Numeric/i/=2b=40.html) }
    end

    describe 'prefix operator method' do
      let(:target) { 1.method(:+@) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Numeric/i/=2b=40.html) }
    end

    describe 'retrieve ancestors' do
      let(:target) { [].method(:map) }

      it { should include %(https://docs.ruby-lang.org/ja/#{PATH_VERSION_PART}/method/Enumerable/i/map.html) }
    end
  end
end
