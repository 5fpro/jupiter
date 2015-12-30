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

class Admin::Comment < ::Comment
end
