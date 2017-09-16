# == Schema Information
#
# Table name: githubs
#
#  id            :integer          not null, primary key
#  project_id    :integer
#  webhook_token :string
#  data          :hstore
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'rails_helper'

RSpec.describe Github, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
