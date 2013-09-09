require 'spec_helper'
require 'csv'

describe Ruremai::Locator::RubyDocInfo do
  describe '#candidates' do
    let(:locator) { Ruremai::Locator::RubyDocInfo.new(target) }

    subject { locator.candidates.map(&:to_s) }

    describe 'CamelCase method' do
      let(:target) { method(:Integer) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Kernel:Integer) }
    end

    describe 'query method' do
      let(:target) { nil.method(:nil?) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/NilClass:nil%3f) }
    end

    describe 'space ship operator' do
      let(:target) { 0.method(:<=>) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Fixnum:%3c%3d%3e) }
    end

    describe 'nested class' do
      let(:target) { Net::HTTP.method(:new) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Net/HTTP.new) }
    end

    describe '`' do
      let(:target) { Kernel.method(:`) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Kernel:%60) }
    end

    describe 'infix operator method' do
      let(:target) { 1.method(:+) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Fixnum:%2b) }
    end

    describe 'prefix operator method' do
      let(:target) { 1.method(:+@) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Numeric:%2b%40) }
    end

    describe 'stdlib method' do
      describe 'CSV.parse' do
        let(:target) { CSV.method(:parse) }

        it { should include %(http://www.rubydoc.info/stdlib/csv/#{RUBY_VERSION}/CSV.parse) }
      end

      describe 'CSV#each' do
        let(:target) { CSV.instance_method(:each) }

        it { should include %(http://www.rubydoc.info/stdlib/csv/#{RUBY_VERSION}/CSV:each) }
      end
    end
  end
end
