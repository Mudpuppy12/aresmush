module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :essence, :num, :private_roll, :dude

      def parse_args
        args = cmd.parse_args(/(?<essence>[\S]*)[=](?<num>[\d]+$)/)

        self.num = args.num.to_i
        self.essence = args.essence

        self.private_roll = cmd.switch_is?("private")
      end

      def required_args
        [ self.num, self.essence ]
      end
      
      def handle
        client.emit_success "MROLL" + essence 
      end
    end
  end
end