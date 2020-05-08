class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def self.search(search)
    return Actor.all unless search
    Actor.where('content LIKE(?)', "%#{search}%")
  end
  
  
end
