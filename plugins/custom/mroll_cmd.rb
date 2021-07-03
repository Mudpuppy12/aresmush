module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :first_essence, :second_essence, :first_num, :second_num, 
                    :private_roll

      def parse_args

        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
      end

      def required_args
        [ self.first_num, self.first_essence ]
      end
      
      def handle
        client.emit_success "MROLL"
    end
  end
end