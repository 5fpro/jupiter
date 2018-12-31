require 'rails_helper'

RSpec.describe DatetimeService, type: :model do

  describe '#to_units_text' do

    subject { described_class }
    before { I18n.default_locale = :en }

    it { expect(subject.to_units_text(12.hours + 13.minutes + 24.seconds)).to eq('12 hours 13 minutes 24 seconds') }

    it { expect(subject.to_units_text(1.day + 13.minutes)).to eq('1 day 13 minutes') }

    it { expect(subject.to_units_text(1.day + 12.hours + 13.minutes, skip_day: true)).to eq('36 hours 13 minutes') }
  end
end
