require 'rails_helper'

RSpec.describe LicenseAssignmentHelper, type: :helper do
  describe '#format_subscription_text' do
    let(:product) { double('Product') }

    context 'when consumed licenses equal available licenses' do
      before do
        allow(product).to receive(:name).and_return('Test Product')
        allow(product).to receive(:consumed_licenses).and_return(5)
        allow(product).to receive(:available_licenses).and_return(5)
      end

      it 'returns the product name with consumed licenses' do
        result = format_subscription_text(product)
        expect(result).to eq('Test Product (5)')
      end
    end

    context 'when consumed licenses are less than available licenses' do
      before do
        allow(product).to receive(:name).and_return('Test Product')
        allow(product).to receive(:consumed_licenses).and_return(3)
        allow(product).to receive(:available_licenses).and_return(5)
      end

      it 'returns the product name with consumed and available licenses' do
        result = format_subscription_text(product)
        expect(result).to eq('Test Product (3/5)')
      end
    end

    context 'when consumed licenses are nil' do
      before do
        allow(product).to receive(:name).and_return('Test Product')
        allow(product).to receive(:consumed_licenses).and_return(nil)
        allow(product).to receive(:available_licenses).and_return(5)
      end

      it 'returns the product name with 0 consumed licenses' do
        result = format_subscription_text(product)
        expect(result).to eq('Test Product (0/5)')
      end
    end
  end
end
