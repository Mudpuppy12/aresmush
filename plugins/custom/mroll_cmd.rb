module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      

      def parse_args
       self.goals = trim_arg(cmd.args)
      end

      def handle
        client.emit_success "MROLL"
      end
    end
  end
end