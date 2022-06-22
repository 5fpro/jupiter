# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  item_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :hstore
#

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.create :comment }

  context 'FactoryBot' do
    it { expect(comment).not_to be_new_record }
    it { attributes_for :comment_for_create }
  end
end
