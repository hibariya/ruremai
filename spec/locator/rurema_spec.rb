require 'spec_helper'

describe Ruremai::Locator::Rurema::Ja do
  describe '#candidates' do
    let(:locator) { Ruremai::Locator::Rurema::Ja.new(target) }

    context 'CamelCase method' do
      let(:target) { method(:Integer) }

      subject { locator.candidates.map(&:to_s) }

      it { should include %(http://doc.ruby-lang.org/ja/1.9.3/method/Kernel/m/Integer.html) }
    end

    context 'query method' do
      let(:target) { nil.method(:nil?) }

      subject { locator.candidates.map(&:to_s) }

      it { should include %(http://doc.ruby-lang.org/ja/#{RUBY_VERSION}/method/NilClass/i/nil=3f.html) }
    end

    context 'space ship operator' do
      let(:target) { 0.method(:<=>) }

      subject { locator.candidates.map(&:to_s) }

      it { should include %(http://doc.ruby-lang.org/ja/#{RUBY_VERSION}/method/Fixnum/i/=3c=3d=3e.html) }
    end
  end
end
