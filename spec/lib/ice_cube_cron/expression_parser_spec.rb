require 'spec_helper'

describe ::IceCubeCron::ExpressionParser do
  let(:expression_parser) do
    described_class.new(
      :repeat_interval => 2,
      :repeat_day => 3,
      :repeat_month => 4,
      :repeat_year => 1990,
      :repeat_weekday => 0
    )
  end

  describe 'parses ::Hash expression' do
    describe 'repeat_interval' do
      it '[]' do
        expect(expression_parser[:repeat_interval]).to eq(2)
      end

      it '[]=' do
        expression_parser[:repeat_interval] = 13
        expect(expression_parser[:repeat_interval]).to eq(13)
      end

      it 'sanitizes' do
        expression_parser[:repeat_interval] = 2
        expect(expression_parser[:repeat_interval]).to eq(2)

        expression_parser[:repeat_interval] = nil
        expect(expression_parser[:repeat_interval]).to eq(1)

        expression_parser[:repeat_interval] = '3'
        expect(expression_parser[:repeat_interval]).to eq(3)
      end
    end

    describe 'repeat_day' do
      it '[]' do
        expect(expression_parser[:repeat_day]).to eq([3])
      end

      it '[]=' do
        expression_parser[:repeat_day] = 6
        expect(expression_parser[:repeat_day]).to eq([6])
      end

      it 'sanitizes' do
        expression_parser[:repeat_day] = 2
        expect(expression_parser[:repeat_day]).to eq([2])

        expression_parser[:repeat_day] = nil
        expect(expression_parser[:repeat_day]).to eq(nil)

        expression_parser[:repeat_day] = '3'
        expect(expression_parser[:repeat_day]).to eq([3])
      end

      it 'should accept single day expression' do
        expression_parser.repeat_day = '1'
        expect(expression_parser.repeat_day).to eq([1])
      end

      it 'should accept series expression' do
        expression_parser.repeat_day = '1,3'
        expect(expression_parser.repeat_day).to eq([1, 3])
      end

      it 'should accept last day expression' do
        expression_parser.repeat_day = 'L'
        expect(expression_parser.repeat_day).to eq([-1])
      end
    end

    describe 'repeat_month' do
      it '[]' do
        expect(expression_parser[:repeat_month]).to eq([4])
      end

      it '[]=' do
        expression_parser[:repeat_month] = 11
        expect(expression_parser[:repeat_month]).to eq([11])
      end

      it 'sanitizes' do
        expression_parser[:repeat_month] = 2
        expect(expression_parser[:repeat_month]).to eq([2])

        expression_parser[:repeat_month] = nil
        expect(expression_parser[:repeat_month]).to eq(nil)

        expression_parser[:repeat_month] = '3'
        expect(expression_parser[:repeat_month]).to eq([3])
      end
    end

    describe 'repeat_year' do
      it '[]' do
        expect(expression_parser[:repeat_year]).to eq([1990])
      end

      it '[]=' do
        expression_parser[:repeat_year] = 1994
        expect(expression_parser[:repeat_year]).to eq([1994])
      end

      it 'sanitizes' do
        expression_parser[:repeat_year] = 1992
        expect(expression_parser[:repeat_year]).to eq([1992])

        expression_parser[:repeat_year] = nil
        expect(expression_parser[:repeat_year]).to eq(nil)

        expression_parser[:repeat_year] = '2001'
        expect(expression_parser[:repeat_year]).to eq([2001])
      end
    end

    describe 'repeat_weekday' do
      it '[]' do
        expect(expression_parser[:repeat_weekday]).to eq([0])
      end

      it '[]=' do
        expression_parser[:repeat_weekday] = 4
        expect(expression_parser[:repeat_weekday]).to eq([4])
      end

      it 'sanitizes' do
        expression_parser[:repeat_weekday] = 2
        expect(expression_parser[:repeat_weekday]).to eq([2])

        expression_parser[:repeat_weekday] = nil
        expect(expression_parser[:repeat_weekday]).to eq(nil)

        expression_parser[:repeat_weekday] = '3'
        expect(expression_parser[:repeat_weekday]).to eq([3])
      end

      it 'should accept non-nth weekday expression' do
        expression_parser.weekday = '1'
        expect(expression_parser.weekday).to eq([1])
      end

      it 'should accept nth weekday expression' do
        expression_parser.weekday = '1#3'
        expect(expression_parser.weekday).to eq([{ 1 => [3] }])
      end

      it 'should accept last weekday expression' do
        expression_parser.weekday = '1L'
        expect(expression_parser.weekday).to eq([{ 1 => [-1] }])
      end
    end
  end
end
