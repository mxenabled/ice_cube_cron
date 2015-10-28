require 'spec_helper'

describe ::IceCubeCron do
  context 'repeat options' do
    describe 'monthly' do
      let(:schedule) { ::IceCube::Schedule.from_cron(::Date.new(2015, 7, 1), :repeat_day => '1', :hour => 0, :minute => 0) }

      it 'for same day' do
        expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 1))).to eq([::Date.new(2015, 7, 1)])
      end

      it 'for multiple months' do
        expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 8, 1), ::Date.new(2015, 9, 1)])
      end
    end

    describe 'twice monthly' do
      let(:schedule) { ::IceCube::Schedule.from_cron(::Date.new(2015, 7, 1), :repeat_day => '1,15', :hour => 0, :minute => 0) }

      it 'for one month' do
        expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15)])
      end

      it 'for two months' do
        expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 8, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15), ::Date.new(2015, 8, 1), ::Date.new(2015, 8, 15)])
      end
    end

    describe 'bi-monthly' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 5, 1),
          :repeat_day => '1',
          :repeat_interval => '2',
          :hour => 0,
          :minute => 0
        )
      end

      it 'for one month' do
        expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1)])
      end

      it 'for multiple months' do
        expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 10, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1)])
      end
    end

    describe 'every week' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 7, 6),
          :repeat_weekday => '1',
          :hour => 0,
          :minute => 0
        )
      end

      it 'for one week' do
        expect(
          schedule.occurrences_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 7, 7)
          )
        ).to eq([::Date.new(2015, 7, 6)])
      end

      it 'for one month' do
        expect(
          schedule.occurrences_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 8, 31)
          )
        ).to eq(
          [
            ::Date.new(2015, 7, 6),
            ::Date.new(2015, 7, 13),
            ::Date.new(2015, 7, 20),
            ::Date.new(2015, 7, 27),
            ::Date.new(2015, 8, 3),
            ::Date.new(2015, 8, 10),
            ::Date.new(2015, 8, 17),
            ::Date.new(2015, 8, 24),
            ::Date.new(2015, 8, 31)
          ]
        )
      end
    end

    describe 'bi-weekly' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 7, 6),
          :repeat_weekday => '1',
          :repeat_interval => '2',
          :hour => 0,
          :minute => 0
        )
      end

      it 'for one week' do
        expect(
          schedule.occurrences_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 7, 7)
          )
        ).to eq([::Date.new(2015, 7, 6)])
      end

      it 'for two months' do
        expect(
          schedule.occurrences_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 8, 31)
          )
        ).to eq(
          [
            ::Date.new(2015, 7, 6),
            # ::Date.new(2015, 7, 13),
            ::Date.new(2015, 7, 20),
            # ::Date.new(2015, 7, 27),
            ::Date.new(2015, 8, 3),
            # ::Date.new(2015, 8, 10),
            ::Date.new(2015, 8, 17),
            # ::Date.new(2015, 8, 24),
            ::Date.new(2015, 8, 31)
          ]
        )
      end
    end

    describe 'annually' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_month => 2,
          :day => 1,
          :hour => 0,
          :minute => 0
        )
      end

      it 'for one year' do
        expect(schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end

      it 'for two years' do
        expect(schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1), ::Date.new(2016, 2, 1)])
      end
    end

    describe 'bi-annually' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_interval => 2,
          :repeat_month => 2,
          :repeat_day => 1,
          :hour => 0,
          :minute => 0
        )
      end

      it 'for two years' do
        expect(schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end
    end

    describe 'last weekday of month' do
      context '31 day month' do
        let(:schedule) do
          ::IceCube::Schedule.from_cron(
            ::Date.new(2015, 1, 1),
            :repeat_weekday => '5L',
            :hour => 0,
            :minute => 0
          )
        end

        it 'for one month' do
          expect(schedule.occurrences_between(::Date.new(2015, 12, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 12, 25)])
        end
      end

      context '29 day month' do
        let(:schedule) do
          ::IceCube::Schedule.from_cron(
            ::Date.new(2015, 1, 1),
            :repeat_weekday => '3L',
            :hour => 0,
            :minute => 0
          )
        end

        it 'for one month' do
          expect(schedule.occurrences_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 24)])
        end
      end
    end

    describe 'last day of month' do
      context '31 day month' do
        let(:schedule) do
          ::IceCube::Schedule.from_cron(
            ::Date.new(2015, 1, 1),
            :repeat_day => 'L',
            :hour => 0,
            :minute => 0
          )
        end

        it 'for one multiple months' do
          expect(schedule.occurrences_between(::Date.new(2015, 12, 1), ::Date.new(2016, 3, 1))).to eq([::Date.new(2015, 12, 31), ::Date.new(2016, 1, 31), ::Date.new(2016, 2, 29)])
        end
      end
    end

    describe 'Nth day of week of month' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_weekday => '1#2',
          :hour => 0,
          :minute => 0
        )
      end

      it 'for one month' do
        expect(schedule.occurrences_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 8)])
      end

      it 'for mutiple months' do
        expect(schedule.occurrences_between(::Date.new(2016, 2, 1), ::Date.new(2016, 4, 30))).to eq([::Date.new(2016, 2, 8), ::Date.new(2016, 3, 14), ::Date.new(2016, 4, 11)])
      end
    end

    context 'every month until date' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_day => '1',
          :repeat_until => ::Date.new(2015, 3, 1),
          :hour => 0,
          :minute => 0
        )
      end

      it 'ends on specified end date' do
        expect(schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 6, 30))).to eq([::Date.new(2015, 1, 1), ::Date.new(2015, 2, 1), ::Date.new(2015, 3, 1)])
      end
    end

    context 'year expression support (non-standard)' do
      context 'in month of a year' do
        let(:schedule) do
          ::IceCube::Schedule.from_cron(
            ::Date.new(2015, 1, 1),
            :year => '2015',
            :month => '6',
            :day => '10',
            :hour => 0,
            :minute => 0
          )
        end

        it '#occurrences_between' do
          expect(schedule.occurrences_between(::Date.new(2013, 1, 1), ::Date.new(2017, 12, 31))).to eq([::Date.new(2015, 6, 10)])
        end

        it '#to_s' do
          expect(schedule.to_s).to eq('Yearly in 2015 in June on the 10th day of the month')
        end
      end

      context 'in a month of multiple years' do
        let(:schedule) do
          ::IceCube::Schedule.from_cron(
            ::Date.new(2015, 1, 1),
            :year => '2015,2017',
            :month => '6',
            :day => '10',
            :hour => 0,
            :minute => 0
          )
        end

        it '#occurrences_between' do
          expect(schedule.occurrences_between(::Date.new(2013, 1, 1), ::Date.new(2018, 12, 31))).to eq([::Date.new(2015, 6, 10), ::Date.new(2017, 6, 10)])
        end

        it '#to_s' do
          expect(schedule.to_s).to eq('Yearly in 2015 and 2017 in June on the 10th day of the month')
        end
      end

      context 'multiple days in month of a year' do
        let(:schedule) do
          ::IceCube::Schedule.from_cron(
            ::Date.new(2015, 1, 1),
            :year => '2015',
            :month => '6',
            :day => '10,15',
            :hour => 0,
            :minute => 0
          )
        end

        it '#occurrences_between' do
          expect(schedule.occurrences_between(::Date.new(2013, 1, 1), ::Date.new(2017, 12, 31))).to eq([::Date.new(2015, 6, 10), ::Date.new(2015, 6, 15)])
        end

        it '#to_s' do
          expect(schedule.to_s).to eq('Yearly in 2015 in June on the 10th and 15th days of the month')
        end
      end
    end

    context 'every hour' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 1, 1),
          :minute => '30'
        )
      end

      it '#occurrences_between' do
        expect(schedule.occurrences_between(::Time.new(2015, 1, 1, 0).utc, ::Time.new(2015, 1, 1, 1, 30).utc)).to eq([::Time.new(2015, 1, 1, 0, 30).utc, ::Time.new(2015, 1, 1, 1, 30).utc])
      end
    end

    context 'every day' do
      let(:schedule) do
        ::IceCube::Schedule.from_cron(
          ::Date.new(2015, 1, 1),
          :hour => '1',
          :minute => '30'
        )
      end

      it '#occurrences_between' do
        expect(schedule.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 1, 3))).to eq([::Time.utc(2015, 1, 1, 1, 30), ::Time.utc(2015, 1, 2, 1, 30)])
      end
    end
  end

  context 'input types' do
    it 'handles ::DateTime as input' do
      schedule = ::IceCube::Schedule.from_cron(
        ::DateTime.new(2015, 5, 1),
        :repeat_day => '1',
        :repeat_interval => '2',
        :hour => 0,
        :minute => 0
      )
      expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1)])
    end

    it 'handles integer (epoch) as input' do
      schedule = ::IceCube::Schedule.from_cron(
        1_430_438_400, # Fri, 01 May 2015 00:00:00 GMT
        :repeat_day => '1',
        :repeat_interval => '2',
        :hour => 0,
        :minute => 0
      )
      expect(schedule.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1)])
    end
  end
end
