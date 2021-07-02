module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :dude

      def parse_args
       self.dude = trim_arg(cmd.args)
      end

      def handle
        client.emit_success "MROLL"
      end
    end
  end
end