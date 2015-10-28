require 'spec_helper'

describe ::IceCubeCron::ExpressionParser do
  let(:expression) do
    described_class.new(
      nil,
      :repeat_interval => 2,
      :repeat_day => 3,
      :repeat_month => 4,
      :repeat_year => 1990,
      :repeat_weekday => 0,
      :repeat_hour => 5,
      :repeat_minute => 6
    )
  end

  describe 'parses ::String expression' do
    # rubocop:disable Style/SymbolProc
    let(:expression_str) { |example| example.description }
    # rubocop:enable Style/SymbolProc
    let(:expression) { described_class.new(expression_str) }

    it '1 * 2 * *' do
      expect(expression.expression_hash[:repeat_interval]).to eq(1)
      expect(expression.expression_hash[:repeat_year]).to eq(nil)
      expect(expression.expression_hash[:repeat_month]).to eq(nil)
      expect(expression.expression_hash[:repeat_day]).to eq([2])
      expect(expression.expression_hash[:repeat_weekday]).to eq(nil)
      expect(expression.expression_hash[:repeat_hour]).to eq(nil)
      expect(expression.expression_hash[:repeat_minute]).to eq([1])
    end

    it '* 12 1,15 * *' do
      expect(expression.expression_hash[:repeat_interval]).to eq(1)
      expect(expression.expression_hash[:repeat_year]).to eq(nil)
      expect(expression.expression_hash[:repeat_month]).to eq(nil)
      expect(expression.expression_hash[:repeat_day]).to eq([1, 15])
      expect(expression.expression_hash[:repeat_weekday]).to eq(nil)
      expect(expression.expression_hash[:repeat_hour]).to eq([12])
      expect(expression.expression_hash[:repeat_minute]).to eq(nil)
    end

    it '* * 1 6,12 *' do
      expect(expression.expression_hash[:repeat_interval]).to eq(1)
      expect(expression.expression_hash[:repeat_year]).to eq(nil)
      expect(expression.expression_hash[:repeat_month]).to eq([6, 12])
      expect(expression.expression_hash[:repeat_day]).to eq([1])
      expect(expression.expression_hash[:repeat_weekday]).to eq(nil)
      expect(expression.expression_hash[:repeat_hour]).to eq(nil)
      expect(expression.expression_hash[:repeat_minute]).to eq(nil)
    end

    it '* * 1 6 * 2015' do
      expect(expression.expression_hash[:repeat_interval]).to eq(1)
      expect(expression.expression_hash[:repeat_year]).to eq([2015])
      expect(expression.expression_hash[:repeat_month]).to eq([6])
      expect(expression.expression_hash[:repeat_day]).to eq([1])
      expect(expression.expression_hash[:repeat_weekday]).to eq(nil)
      expect(expression.expression_hash[:repeat_hour]).to eq(nil)
      expect(expression.expression_hash[:repeat_minute]).to eq(nil)
    end

    it '* * * 6 1L *' do
      expect(expression.expression_hash[:repeat_interval]).to eq(1)
      expect(expression.expression_hash[:repeat_year]).to eq(nil)
      expect(expression.expression_hash[:repeat_month]).to eq([6])
      expect(expression.expression_hash[:repeat_day]).to eq(nil)
      expect(expression.expression_hash[:repeat_weekday]).to eq([1 => [-1]])
      expect(expression.expression_hash[:repeat_hour]).to eq(nil)
      expect(expression.expression_hash[:repeat_minute]).to eq(nil)
    end
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

    describe 'repeat_minute' do
      it '[]' do
        expect(expression.minute).to eq([6])
      end

      it '[]=' do
        expression.minute = 6
        expect(expression.minute).to eq([6])
      end

      it 'sanitizes' do
        expression.minute = 2
        expect(expression.minute).to eq([2])

        expression.minute = nil
        expect(expression.minute).to eq(nil)

        expression.minute = '3'
        expect(expression.minute).to eq([3])
      end

      it 'should accept single minute expression' do
        expression.minute = '1'
        expect(expression.minute).to eq([1])
      end

      it 'should accept series expression' do
        expression.minute = '1,3'
        expect(expression.minute).to eq([1, 3])
      end

      it 'should accept range expression' do
        expression.minute = '1-3'
        expect(expression.minute).to eq([1, 2, 3])
      end
    end

    describe 'repeat_hour' do
      it '[]' do
        expect(expression.hour).to eq([5])
      end

      it '[]=' do
        expression.hour = 6
        expect(expression.hour).to eq([6])
      end

      it 'sanitizes' do
        expression.hour = 2
        expect(expression.hour).to eq([2])

        expression.hour = nil
        expect(expression.hour).to eq(nil)

        expression.hour = '3'
        expect(expression.hour).to eq([3])
      end

      it 'should accept single hour expression' do
        expression.hour = '1'
        expect(expression.hour).to eq([1])
      end

      it 'should accept series expression' do
        expression.hour = '1,3'
        expect(expression.hour).to eq([1, 3])
      end

      it 'should accept range expression' do
        expression.hour = '1-3'
        expect(expression.hour).to eq([1, 2, 3])
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
