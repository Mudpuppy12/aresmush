module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :dude

      def parse_args
        if trim_arg(cmd.args) is nil
          client.emit_success "Wrong syntax"
        else
          self.dude = trim_arg(cmd.args)
        end
      end

      def handle
        client.emit_success "MROLL" + self.dude
      end
    end
  end
end