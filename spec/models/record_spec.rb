# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  minutes     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#  record_type :integer
#  todo_id     :integer
#

require 'rails_helper'

RSpec.describe Record, type: :model do
  let(:record) { FactoryGirl.create :record }

  context 'FactoryGirl' do
    it { expect(record).not_to be_new_record }
    it { attributes_for :record_for_params }
  end
end
