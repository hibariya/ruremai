require 'spec_helper'

describe Ruremai::Locator::RubyDocInfo do
  describe '#candidates' do
    let(:locator) { Ruremai::Locator::RubyDocInfo.new(target) }

    subject { locator.candidates.map(&:to_s) }

    describe 'CamelCase method' do
      let(:target) { method(:Integer) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Kernel:Integer?process=true) }
    end

    describe 'query method' do
      let(:target) { nil.method(:nil?) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/NilClass:nil%3f?process=true) }
    end

    describe 'space ship operator' do
      let(:target) { 0.method(:<=>) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Fixnum:%3c%3d%3e?process=true) }
    end

    describe 'nested class' do
      let(:target) { Net::HTTP.method(:new) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Net/HTTP.new?process=true) }
    end

    describe '`' do
      let(:target) { Kernel.method(:`) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Kernel:%60?process=true) }
    end

    describe 'infix operator method' do
      let(:target) { 1.method(:+) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Fixnum:%2b?process=true) }
    end

    describe 'prefix operator method' do
      let(:target) { 1.method(:+@) }

      it { should include %(http://www.rubydoc.info/stdlib/core/#{RUBY_VERSION}/Numeric:%2b%40?process=true) }
    end
  end
end
