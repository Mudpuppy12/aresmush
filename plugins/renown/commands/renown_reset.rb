module AresMUSH

  module Renown
    class RenownResetCmd
      include CommandHandler

      def handle

           if !(enactor.is_admin?)
              client.emit_failure "You're not allowed to do that.\n"
              return
           end

           chars = Chargen.approved_chars
           chars.each do |c|
              Renown.clear_renown(c)
           end

        client.emit "You've successfully cleared the renown of all characters.\n"
      end

    end
  end

end
