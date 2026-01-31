class AppInfo < ApplicationRecord
  has_many :conf

  has_rich_text :welcome_message
  has_rich_text :app_description
  has_rich_text :use_terms
end
