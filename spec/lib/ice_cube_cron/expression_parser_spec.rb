require 'spec_helper'

describe ::IceCubeCron::ExpressionParser do
  let(:expression) do
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
        expect(expression.interval).to eq(2)
      end

      it '[]=' do
        expression.interval = 13
        expect(expression.interval).to eq(13)
      end

      it 'sanitizes' do
        expression.interval = 2
        expect(expression.interval).to eq(2)

        expression.interval = nil
        expect(expression.interval).to eq(1)

        expression.interval = '3'
        expect(expression.interval).to eq(3)
      end
    end

    describe 'repeat_day' do
      it '[]' do
        expect(expression.day).to eq([3])
      end

      it '[]=' do
        expression.day = 6
        expect(expression.day).to eq([6])
      end

      it 'sanitizes' do
        expression.day = 2
        expect(expression.day).to eq([2])

        expression.day = nil
        expect(expression.day).to eq(nil)

        expression.day = '3'
        expect(expression.day).to eq([3])
      end

      it 'should accept single day expression' do
        expression.day = '1'
        expect(expression.day).to eq([1])
      end

      it 'should accept series expression' do
        expression.day = '1,3'
        expect(expression.day).to eq([1, 3])
      end

      it 'should accept range expression' do
        expression.day = '1-3'
        expect(expression.day).to eq([1, 2, 3])
      end

      it 'should accept last day expression' do
        expression.day = 'L'
        expect(expression.day).to eq([-1])
      end
    end

    describe 'repeat_month' do
      it '[]' do
        expect(expression.month).to eq([4])
      end

      it '[]=' do
        expression.month = 11
        expect(expression.month).to eq([11])
      end

      it 'sanitizes' do
        expression.month = 2
        expect(expression.month).to eq([2])

        expression.month = nil
        expect(expression.month).to eq(nil)

        expression.month = '3'
        expect(expression.month).to eq([3])
      end
    end

    describe 'repeat_year' do
      it '[]' do
        expect(expression.year).to eq([1990])
      end

      it '[]=' do
        expression.year = 1994
        expect(expression.year).to eq([1994])
      end

      it 'sanitizes' do
        expression.year = 1992
        expect(expression.year).to eq([1992])

        expression.year = nil
        expect(expression.year).to eq(nil)

        expression.year = '2001'
        expect(expression.year).to eq([2001])
      end
    end

    describe 'repeat_weekday' do
      it '[]' do
        expect(expression.weekday).to eq([0])
      end

      it '[]=' do
        expression.weekday = 4
        expect(expression.weekday).to eq([4])
      end

      it 'sanitizes' do
        expression.weekday = 2
        expect(expression.weekday).to eq([2])

        expression.weekday = nil
        expect(expression.weekday).to eq(nil)

        expression.weekday = '3'
        expect(expression.weekday).to eq([3])
      end

      it 'should accept non-nth weekday expression' do
        expression.weekday = '1'
        expect(expression.weekday).to eq([1])
      end

      it 'should accept nth weekday expression' do
        expression.weekday = '1#3'
        expect(expression.weekday).to eq([{ 1 => [3] }])
      end

      it 'should accept last weekday expression' do
        expression.weekday = '1L'
        expect(expression.weekday).to eq([{ 1 => [-1] }])
      end
    end
  end
end
