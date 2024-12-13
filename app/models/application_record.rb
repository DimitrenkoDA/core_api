class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  DEFAULT_LIMIT = 25
  MAX_LIMIT = 100
end
