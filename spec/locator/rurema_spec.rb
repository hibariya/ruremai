require 'spec_helper'

describe Ruremai::Locator::Rurema do
  describe '#candidates' do
    let(:locator) { Ruremai::Locator::Rurema.new(target) }

    subject { locator.candidates.map(&:to_s) }

    context 'CamelCase method' do
      let(:target) { method(:Integer) }

      it { should include %(http://doc.ruby-lang.org/ja/#{RUBY_VERSION}/method/Kernel/m/Integer.html) }
    end

    context 'query method' do
      let(:target) { nil.method(:nil?) }

      it { should include %(http://doc.ruby-lang.org/ja/#{RUBY_VERSION}/method/NilClass/i/nil=3f.html) }
    end

    context 'space ship operator' do
      let(:target) { 0.method(:<=>) }

      it { should include %(http://doc.ruby-lang.org/ja/#{RUBY_VERSION}/method/Fixnum/i/=3c=3d=3e.html) }
    end

    context 'nested class' do
      let(:target) { Net::HTTP.method(:new) }

      it { should include %(http://doc.ruby-lang.org/ja/#{RUBY_VERSION}/method/Net=3a=3aHTTP/s/new.html) }
    end
  end
end
