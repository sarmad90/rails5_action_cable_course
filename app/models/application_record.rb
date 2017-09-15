class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.next_record?
    last_id = reorder('id').last.try(:id)
    reorder('id').where('id > ?', last_id).last.present?
  end
end
