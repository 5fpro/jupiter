class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include ::Taggable
  include ::Restorable
  include ::Omniauthable
  include ::Sortable
end
