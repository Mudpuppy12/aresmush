module AresMUSH

  module Renown
    class RenownAllCmd
      include CommandHandler

      def handle

           if !(enactor.is_admin?) && !(Renown.visible)
              client.emit_failure "You're not allowed to do that.\n"
              return
           end

        chars = Renown.get_renown_chars

        template = RenownAllTemplate.new chars
	client.emit template.render
      end

    end
  end

end
