module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :dude

      def parse_args
        return if cmd.args is nil
        self.dude = trim_arg(cmd.args)
      end

      def handle
        client.emit_success "MROLL" + self.dude
      end
    end
  end
end