module AresMUSH

  module Renown
    class RenownViewCmd
      include CommandHandler

      attr_accessor :name

      def parse_args
         self.name = cmd.args ? titlecase_arg(cmd.args) : enactor_name
      end

      def handle

           if (self.name != enactor.name) && !(enactor.is_admin?) && !(Renown.visible)
              client.emit_failure "You're not allowed to do that.\n"
              return
           end

        char = Character.find_one_by_name self.name

        if !char 
          return nil 
        end

        template = RenownTemplate.new char
	client.emit template.render
      end

    end
  end

end
