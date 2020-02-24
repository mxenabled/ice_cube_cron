# frozen_string_literal: true

require 'spec_helper'

describe ::IceCubeCron::RuleBuilder do
  let(:expression) do
    ::IceCubeCron::ExpressionParser.new({})
  end

  let(:rule_builder) { described_class.new }

  describe 'builds correct root rule' do
    # rubocop:disable Style/SymbolProc
    let(:expression_str) { |example| example.description }
    # rubocop:enable Style/SymbolProc
    let(:expression) { ::IceCubeCron::ExpressionParser.new(expression_str) }
    let(:rule) { rule_builder.build_rule(expression) }

    context 'minutely' do
      it '* * * * *' do
        expect(rule).to be_a(IceCube::MinutelyRule)
      end

      it '* 1 1 1 1 2015' do
        expect(rule).to be_a(IceCube::MinutelyRule)
      end
    end

    context 'hourly' do
      it '1 * * * *' do
        expect(rule).to be_a(IceCube::HourlyRule)
      end

      it '1 * 1 1 1 2015' do
        expect(rule).to be_a(IceCube::HourlyRule)
      end
    end

    context 'daily' do
      it '1 2 * * *' do
        expect(rule).to be_a(IceCube::DailyRule)
      end

      it '1 2 * 1 * 2015' do
        expect(rule).to be_a(IceCube::DailyRule)
      end
    end

    context 'monthly' do
      it '0 0 1 * *' do
        expect(rule).to be_a(IceCube::MonthlyRule)
      end

      it '1 2 1 * * 2015' do
        expect(rule).to be_a(IceCube::MonthlyRule)
      end

      it '1 2 1 * * 2015' do
        expect(rule).to be_a(IceCube::MonthlyRule)
      end

      it '1 2 * * 1L 2015' do
        expect(rule).to be_a(IceCube::MonthlyRule)
      end
    end

    context 'weekly' do
      it '0 0 * * 1' do
        expect(rule).to be_a(IceCube::WeeklyRule)
      end

      it '1 2 * * 1 2015' do
        expect(rule).to be_a(IceCube::WeeklyRule)
      end
    end

    context 'yearly' do
      it '0 0 1 1 *' do
        expect(rule).to be_a(IceCube::YearlyRule)
      end

      it '1 2 1 1 * 2015' do
        expect(rule).to be_a(IceCube::YearlyRule)
      end
    end

    # it '1 * 2 * *' do
    #   expect(rule).to be_a(IceCube::MonthlyRule)
    # end

    # it '1 2 2 * *' do
    #   expect(rule).to be_a(IceCube::MonthlyRule)
    # end

    # it 'monthly' do
    #   expression.day = 5
    #   expect(rule_builder.build_rule(expression)).to be_a(IceCube::MonthlyRule)
    # end

    # it 'weekly' do
    #   expression.weekday = 2
    #   expect(rule_builder.build_rule(expression)).to be_a(IceCube::WeeklyRule)
    # end

    # it 'monthly (last week day of month)' do
    #   expression.weekday = '2L'
    #   expect(rule_builder.build_rule(expression)).to be_a(IceCube::MonthlyRule)
    # end

    # it 'yearly' do
    #   expression.month = 2
    #   expect(rule_builder.build_rule(expression)).to be_a(IceCube::YearlyRule)
    # end

    # it 'daily' do
    #   expression.hour = 2
    #   expect(rule_builder.build_rule(expression)).to be_a(IceCube::DailyRule)
    # end

    # it 'hourly' do
    #   expression.minute = 2
    #   expect(rule_builder.build_rule(expression)).to be_a(IceCube::HourlyRule)
    # end
  end

  describe '#nth_day?' do
    it 'should accept nil' do
      expect(rule_builder.nth_day?(nil)).to be false
    end

    it 'should accept non-nth weekday expression' do
      expect(rule_builder.nth_day?([1])).to be false
    end

    it 'should accept nth weekday expression' do
      expect(rule_builder.nth_day?([{ 1 => [3] }])).to be true
    end
  end
end
