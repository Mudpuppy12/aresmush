module AresMUSH
  class RenownEntry < Ohm::Model
    include ObjectModel
    
    reference :character, "AresMUSH::Character"
    attribute :title
    attribute :value, :type => DataType::Integer
    attribute :creator
    index :title

  end
end
