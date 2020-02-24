# frozen_string_literal: true

require 'spec_helper'

describe ::IceCubeCron::ExpressionParser do
  let(:expression) do
    described_class.new(
      nil,
      :interval => 2,
      :day_of_month => 3,
      :month => 4,
      :year => 1990,
      :day_of_week => 0,
      :hour => 5,
      :minute => 6
    )
  end

  describe 'parses ::String expression' do
    # rubocop:disable Style/SymbolProc
    let(:expression_str) { |example| example.description }
    # rubocop:enable Style/SymbolProc
    let(:expression) { described_class.new(expression_str) }

    it '1 * 2 * *' do
      expect(expression.interval).to eq(1)
      expect(expression.year).to eq(nil)
      expect(expression.month).to eq(nil)
      expect(expression.day_of_month).to eq([2])
      expect(expression.day_of_week).to eq(nil)
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq([1])
    end

    it '* 12 1,15 * *' do
      expect(expression.interval).to eq(1)
      expect(expression.year).to eq(nil)
      expect(expression.month).to eq(nil)
      expect(expression.day_of_month).to eq([1, 15])
      expect(expression.day_of_week).to eq(nil)
      expect(expression.hour).to eq([12])
      expect(expression.minute).to eq(nil)
    end

    it '* * 1 6,12 *' do
      expect(expression.interval).to eq(1)
      expect(expression.year).to eq(nil)
      expect(expression.month).to eq([6, 12])
      expect(expression.day_of_month).to eq([1])
      expect(expression.day_of_week).to eq(nil)
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq(nil)
    end

    it '* * 1 6 * 2015' do
      expect(expression.interval).to eq(1)
      expect(expression.year).to eq([2015])
      expect(expression.month).to eq([6])
      expect(expression.day_of_month).to eq([1])
      expect(expression.day_of_week).to eq(nil)
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq(nil)
    end

    it '* * * 6 1L *' do
      expect(expression.interval).to eq(1)
      expect(expression.year).to eq(nil)
      expect(expression.month).to eq([6])
      expect(expression.day_of_month).to eq(nil)
      expect(expression.day_of_week).to eq([1 => [-1]])
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq(nil)
    end

    it '*/5 * * * * *' do
      expect(expression.interval).to eq(5)
      expect(expression.year).to eq(nil)
      expect(expression.month).to eq(nil)
      expect(expression.day_of_month).to eq(nil)
      expect(expression.day_of_week).to eq(nil)
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq(nil)
    end

    it '1 */12 * * * *' do
      expect(expression.interval).to eq(12)
      expect(expression.year).to eq(nil)
      expect(expression.month).to eq(nil)
      expect(expression.day_of_month).to eq(nil)
      expect(expression.day_of_week).to eq(nil)
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq([1])
    end

    # Only one interval is supported
    it '*/1 */12 * * * *' do
      expect(expression.interval).to eq(12)
      expect(expression.hour).to eq(nil)
      expect(expression.minute).to eq(nil)
    end
  end

  describe 'parses ::Hash expression' do
    describe 'interval' do
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

    describe 'minute' do
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

    describe 'hour' do
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

    describe 'day_of_month' do
      it '[]' do
        expect(expression.day_of_month).to eq([3])
      end

      it '[]=' do
        expression.day_of_month = 6
        expect(expression.day_of_month).to eq([6])
      end

      it 'sanitizes' do
        expression.day_of_month = 2
        expect(expression.day_of_month).to eq([2])

        expression.day_of_month = nil
        expect(expression.day_of_month).to eq(nil)

        expression.day_of_month = '3'
        expect(expression.day_of_month).to eq([3])
      end

      it 'should accept single day expression' do
        expression.day_of_month = '1'
        expect(expression.day_of_month).to eq([1])
      end

      it 'should accept series expression' do
        expression.day_of_month = '1,3'
        expect(expression.day_of_month).to eq([1, 3])
      end

      it 'should accept range expression' do
        expression.day_of_month = '1-3'
        expect(expression.day_of_month).to eq([1, 2, 3])
      end

      it 'should accept last day expression' do
        expression.day_of_month = 'L'
        expect(expression.day_of_month).to eq([-1])
      end
    end

    describe 'month' do
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

    describe 'year' do
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

    describe 'day_of_week' do
      it '[]' do
        expect(expression.day_of_week).to eq([0])
      end

      it '[]=' do
        expression.day_of_week = 4
        expect(expression.day_of_week).to eq([4])
      end

      it 'sanitizes' do
        expression.day_of_week = 2
        expect(expression.day_of_week).to eq([2])

        expression.day_of_week = nil
        expect(expression.day_of_week).to eq(nil)

        expression.day_of_week = '3'
        expect(expression.day_of_week).to eq([3])
      end

      it 'should accept non-nth weekday expression' do
        expression.day_of_week = '1'
        expect(expression.day_of_week).to eq([1])
      end

      it 'should accept nth weekday expression' do
        expression.day_of_week = '1#3'
        expect(expression.day_of_week).to eq([{ 1 => [3] }])
      end

      it 'should accept last weekday expression' do
        expression.day_of_week = '1L'
        expect(expression.day_of_week).to eq([{ 1 => [-1] }])
      end
    end

    describe 'until' do
      it '[]' do
        expect(expression.until).to eq(nil)
      end

      it '[]=' do
        expression.until = 1_453_334_400
        expect(expression.until).to eq(::Time.at(1_453_334_400).utc)
      end

      it 'sanitizes' do
        expression.until = 1_453_334_400
        expect(expression.until).to eq(::Time.at(1_453_334_400).utc)

        expression.until = nil
        expect(expression.until).to eq(nil)

        expression.until = ::Date.new(2016, 1, 21)
        expect(expression.until).to eq(::Time.at(1_453_334_400).utc)
      end
    end
  end

  describe 'invalid parameters' do
    it 'should raise helpful error' do
      expect do
        described_class.new(:invalid_param => 1)
      end.to raise_error(ArgumentError)
    end
  end
end
