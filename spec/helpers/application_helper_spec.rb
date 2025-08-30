require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#field_error' do
    let(:model) { double('Model') }

    context 'when there are errors for the field' do
      before do
        error = double
        allow(error).to receive(:full_messages_for).and_return([ "Error message 1", "Error message 2" ])
        allow(error).to receive(:[]).and_return([ true ])
        allow(model).to receive(:errors).and_return(error)
      end

      it 'returns a div with error messages' do
        result = field_error(model, :field_name)
        expect(result).to include('<div class="error-message">Error message 1, Error message 2</div>')
      end
    end

    context 'when there are no errors for the field' do
      before do
        error = double
        allow(error).to receive(:[]).and_return([])
        allow(model).to receive(:errors).and_return(error)
      end

      it 'returns nil' do
        result = field_error(model, :field_name)
        expect(result).to be_nil
      end
    end
  end

  describe '#format_date_time' do
    it 'formats the date time correctly' do
      date_time = Time.new(2025, 8, 30, 14, 30)
      formatted_time = format_date_time(date_time)
      expect(formatted_time).to eq('2025/08/30 - 14:30')
    end
  end
end
