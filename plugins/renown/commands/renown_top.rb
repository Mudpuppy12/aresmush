module AresMUSH
  module Renown
    class RenownTopCmd
      include CommandHandler

      def handle

        if !(enactor.is_admin?) && !(Renown.visible)
           client.emit_failure "You're not allowed to do that.\n"
           return
        end

        topchars = Renown.get_top_list("char",10)
        toporgs = Renown.get_top_list(Renown.group,10)

        template = RenownTopTemplate.new topchars, toporgs
        client.emit template.render
      end

    end
  end

end
