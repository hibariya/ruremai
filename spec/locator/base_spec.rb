require 'spec_helper'

describe Ruremai::Locator::Base do
  describe '#const_candidates' do
    subject { Ruremai::Locator::Base.new(target) }

    context 'Method' do
      let(:target) { Array.method(:new) }

      its(:const_candidates) { should == [Array, Class] }
    end

    context 'UnboundMethod' do
      let(:target) { Array.method(:new).unbind }

      its(:const_candidates) { should == [Class] }
    end
  end

  describe '#method_types' do
    subject { Ruremai::Locator::Base.new(target) }

    context 'Time.now (Method)' do
      let(:target) { Time.method(:now) }

      its(:method_types) { should == [:singleton_method, :module_function, :instance_method] }
    end

    context 'Math.sqrt (Method)' do
      let(:target) { Math.method(:sqrt) }

      its(:method_types) { should == [:module_function, :singleton_method, :instance_method] }
    end

    context 'Array#slice (Method)' do
      let(:target) { [].method(:slice) }

      its(:method_types) { should == [:instance_method, :module_function, :singleton_method] }
    end

    context 'Array#slice (UnboundMethod)' do
      let(:target) { Array.instance_method(:slice) }

      its(:method_types) { should == [:instance_method, :module_function, :singleton_method] }
    end
  end
end
