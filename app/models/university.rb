class University < ApplicationRecord
    has_many :students

    private
        def self.inheritance_column
            nil
        end
end
