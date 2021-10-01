require 'rails_helper'

RSpec.describe Timecop, type: :model do
  it '' do
    described_class.freeze Time.now
    time1 = Time.now
    described_class.freeze time1 + 1.hour
    time2 = Time.now
    expect(time2 - time1).to be >= 1.hour
  end

end
