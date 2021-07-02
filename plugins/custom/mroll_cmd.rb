module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :num, :sides, :private_roll, :dude

      def parse_args
        args = cmd.parse_args(/(?<num>[\d]*)[dD](?<sides>[\d]+$)/)

        self.num = args.num.to_i
        self.sides = args.sides.to_i
        self.private_roll = cmd.switch_is?("private")
      end

      def required_args
        [ self.num, self.sides ]
      end
      
      def handle
        client.emit_success "MROLL" + self.dude
      end
    end
  end
end