require 'support/time/comparator'

RSpec.describe Support::Time::Comparator do
  let(:resource_time) { Time.zone.parse('2017-12-29 13:32:10 +0100') }
  let(:now) { Time.zone.parse('2017-12-29 19:32:10 +0100') }

  describe '.time_delay_expired?' do
    let(:delay) { 1.day }

    context 'when delay has not expired' do
      it 'returns false' do
        expect(subject.class.time_delay_expired?(resource_time, delay, now)).to be false
      end
    end

    context 'when delay has expired' do
      let(:later) { now + delay + 1.second }
      it 'returns true' do
        expect(subject.class.time_delay_expired?(resource_time, delay, later)).to be true
      end
    end
  end

  describe '.time_in_range?' do
    let(:lower_bound) { resource_time - 2.hours }
    let(:upper_bound) { resource_time - 1.hour }

    context 'when time outside of range' do
      it 'returns false' do
        expect(subject.class.time_in_range?(resource_time, lower_bound, upper_bound)).to be false
      end
    end

    context 'when time inside of range' do
      let(:upper_bound) { resource_time + 1.hour }
      it 'returns true' do
        expect(subject.class.time_in_range?(resource_time, lower_bound, upper_bound)).to be true
      end
    end
  end
end
