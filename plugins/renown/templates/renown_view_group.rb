module AresMUSH
  module Renown
    class RenownViewGroupCmd
      include CommandHandler

      attr_accessor :org

      def parse_args
        self.org = trim_arg(cmd.args)
      end
      
      def required_args
        [ self.org ]
      end      

      def handle

        if !(enactor.is_admin?) && !(Renown.visible)
           client.emit_failure "You're not allowed to do that.\n"
           return
        end

        if ( Renown.group == {} )
           client.emit_failure "No renown group defined.\n"
           return
        end

        house_chars = []
        chars = Renown.get_renown_chars.select {|c| c.groups[Renown.group] == self.org }

        chars.each do |c|
           name = c.name
           points = Renown.calculate_gained(c.name)
           rank = c.ranks_rank
           house_chars << [name, rank, points]
        end

        template = RenownGroupTemplate.new house_chars, self.org
	client.emit template.render
      end

    end
  end

end
