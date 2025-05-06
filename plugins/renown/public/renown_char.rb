module AresMUSH
  class Character

    collection :gained, "AresMUSH::RenownEntry"

    before_delete :delete_renown_entries
    
    def delete_renown_entries
      self.gained.each do |a|
        a.delete
      end
    end

  end
end
