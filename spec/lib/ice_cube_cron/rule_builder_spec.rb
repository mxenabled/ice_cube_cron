require 'spec_helper'

describe ::IceCubeCron::RuleBuilder do
  let(:expression) do
    ::IceCubeCron::ExpressionParser.new({})
  end

  let(:rule_builder) { described_class.new }

  describe 'builds correct root rule' do
    it 'monthly' do
      expression.day = 5
      expect(rule_builder.build_rule(expression)).to be_a(IceCube::MonthlyRule)
    end

    it 'weekly' do
      expression.weekday = 2
      expect(rule_builder.build_rule(expression)).to be_a(IceCube::WeeklyRule)
    end

    it 'yearly' do
      expression.month = 2
      expect(rule_builder.build_rule(expression)).to be_a(IceCube::YearlyRule)
    end
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
