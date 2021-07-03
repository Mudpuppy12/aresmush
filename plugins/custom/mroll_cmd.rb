module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :first_essence, :second_essence, :first_num, :second_num, 
                    :private_roll

      def parse_args

        args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)
        
          self.first_essence = list_arg(args.arg1,"=").at(0)
          self.first_num = list_arg(args.arg1,"=").at(1)

          client.emit_success "First Essence :" + self.first_essence
          client.emit_success "First num :" + self.first_num.to_s


        if args.arg2
          self.second_essence = list_arg(args.arg2,"=").at(0)
          self.second_num = list_arg(args.arg2,"=").at(1)

          client.emit_success "Second Essence :" + self.second_essence
          client.emit_success "Second num :" + self.second_num.to_s
        end

     

      end

     def required_args
        [ self.first_num, self.first_essence ]
     end
      
      def handle
        client.emit_success "MROLL"
      end
    end
  end
end