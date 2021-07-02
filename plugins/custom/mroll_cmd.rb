module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :dude

      def parse_args
        return nil if trim_arg(cmd.args) == nil
        self.dude = trim_arg(cmd.args)
      end

      def handle
        client.emit_success "MROLL" + self.dude
      end
    end
  end
end