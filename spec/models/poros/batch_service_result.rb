require 'rails_helper'

RSpec.describe Poros::BatchServiceResult do
  describe '#initialize' do
    it 'sets the success, errors, executed, and skipped attributes' do
      result = Poros::BatchServiceResult.new(true, [ 'Error 1' ], 5, 2)

      expect(result.success?).to be true
      expect(result.errors).to eq([ 'Error 1' ])
    end
  end

  describe '#success?' do
    context 'when success is true' do
      it 'returns true' do
        result = Poros::BatchServiceResult.new(true, [], 0, 0)
        expect(result.success?).to be true
      end
    end

    context 'when success is false' do
      it 'returns false' do
        result = Poros::BatchServiceResult.new(false, [ 'Error 1' ], 0, 0)
        expect(result.success?).to be false
      end
    end
  end
end
