# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  price_of_hour :integer
#  name          :string
#  owner_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  data          :hstore
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project){ FactoryGirl.create :project }

  it "FactoryGirl" do
    expect(project).not_to be_new_record
  end
end
