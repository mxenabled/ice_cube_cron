require 'spec_helper'

describe ::IceCubeCron do
  context 'repeat options' do
    describe 'monthly' do
      let(:ice_cube_model) { ::IceCube.from_cron(::Date.new(2015, 7, 1), :repeat_day => '1') }

      it 'for same day' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 1))).to eq([::Date.new(2015, 7, 1)])
      end

      it 'for multiple months' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 8, 1), ::Date.new(2015, 9, 1)])
      end
    end

    describe 'twice monthly' do
      let(:ice_cube_model) { ::IceCube.from_cron(::Date.new(2015, 7, 1), :repeat_day => '1,15') }

      it 'for one month' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15)])
      end

      it 'for two months' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 8, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 7, 15), ::Date.new(2015, 8, 1), ::Date.new(2015, 8, 15)])
      end
    end

    describe 'bi-monthly' do
      let(:ice_cube_model) do
        ::IceCube.from_cron(
          ::Date.new(2015, 5, 1),
          :repeat_day => '1',
          :repeat_interval => '2'
        )
      end

      it 'for one month' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 7, 31))).to eq([::Date.new(2015, 7, 1)])
      end

      it 'for multiple months' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 7, 1), ::Date.new(2015, 10, 31))).to eq([::Date.new(2015, 7, 1), ::Date.new(2015, 9, 1)])
      end
    end

    describe 'every week' do
      let(:ice_cube_model) do
        ::IceCube.from_cron(
          ::Date.new(2015, 7, 6),
          :repeat_weekday => '1'
        )
      end

      it 'for one week' do
        expect(
          ice_cube_model.occurrences_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 7, 7)
          )
        ).to eq([::Date.new(2015, 7, 6)])
      end

      it 'for one month' do
        expect(
          ice_cube_model.occurrences_between(
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
      let(:ice_cube_model) do
        ::IceCube.from_cron(
          ::Date.new(2015, 7, 6),
          :repeat_weekday => '1',
          :repeat_interval => '2'
        )
      end

      it 'for one week' do
        expect(
          ice_cube_model.occurrences_between(
            ::Date.new(2015, 7, 1),
            ::Date.new(2015, 7, 7)
          )
        ).to eq([::Date.new(2015, 7, 6)])
      end

      it 'for two months' do
        expect(
          ice_cube_model.occurrences_between(
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
      let(:ice_cube_model) do
        ::IceCube.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_month => 2
        )
      end

      it 'for one year' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end

      it 'for two years' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1), ::Date.new(2016, 2, 1)])
      end
    end

    describe 'bi-annually' do
      let(:ice_cube_model) do
        ::IceCube.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_interval => 2,
          :repeat_month => 2,
          :repeat_day => 1
        )
      end

      it 'for two years' do
        expect(ice_cube_model.occurrences_between(::Date.new(2015, 1, 1), ::Date.new(2016, 12, 31))).to eq([::Date.new(2015, 2, 1)])
      end
    end

    describe 'last weekday of month' do
      context '31 day month' do
        let(:ice_cube_model) do
          ::IceCube.from_cron(
            ::Date.new(2015, 1, 1),
            :repeat_weekday => '5L'
          )
        end

        it 'for one month' do
          expect(ice_cube_model.occurrences_between(::Date.new(2015, 12, 1), ::Date.new(2015, 12, 31))).to eq([::Date.new(2015, 12, 25)])
        end
      end

      context '29 day month' do
        let(:ice_cube_model) do
          ::IceCube.from_cron(
            ::Date.new(2015, 1, 1),
            :repeat_weekday => '3L'
          )
        end

        it 'for one month' do
          expect(ice_cube_model.occurrences_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 24)])
        end
      end
    end

    describe 'last day of month' do
      context '31 day month' do
        let(:ice_cube_model) do
          ::IceCube.from_cron(
            ::Date.new(2015, 1, 1),
            :repeat_day => 'L'
          )
        end

        it 'for one multiple months' do
          expect(ice_cube_model.occurrences_between(::Date.new(2015, 12, 1), ::Date.new(2016, 3, 1))).to eq([::Date.new(2015, 12, 31), ::Date.new(2016, 1, 31), ::Date.new(2016, 2, 29)])
        end
      end
    end

    describe 'Nth day of week of month' do
      let(:ice_cube_model) do
        ::IceCube.from_cron(
          ::Date.new(2015, 1, 1),
          :repeat_weekday => '1#2'
        )
      end

      it 'for one month' do
        expect(ice_cube_model.occurrences_between(::Date.new(2016, 2, 1), ::Date.new(2016, 2, 29))).to eq([::Date.new(2016, 2, 8)])
      end

      it 'for mutiple months' do
        expect(ice_cube_model.occurrences_between(::Date.new(2016, 2, 1), ::Date.new(2016, 4, 30))).to eq([::Date.new(2016, 2, 8), ::Date.new(2016, 3, 14), ::Date.new(2016, 4, 11)])
      end
    end
  end

  context 'input types' do
    it 'handles ::DateTime as input' do
      ice_cube_model = ::IceCube.from_cron(
        ::DateTime.new(2015, 5, 1),
        :repeat_day => '1',
        :repeat_interval => '2'
      )
      expect(ice_cube_model.occurrences_between(::DateTime.new(2015, 7, 1), ::DateTime.new(2015, 7, 31))).to eq([::DateTime.new(2015, 7, 1)])
    end

    it 'handles integer (epoch) as input' do
      ice_cube_model = ::IceCube.from_cron(
        1_430_438_400, # Fri, 01 May 2015 00:00:00 GMT
        :repeat_day => '1',
        :repeat_interval => '2'
      )
      expect(ice_cube_model.occurrences_between(::DateTime.new(2015, 7, 1), ::DateTime.new(2015, 7, 31))).to eq([::DateTime.new(2015, 7, 1)])
    end
  end
end
