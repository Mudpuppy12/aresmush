module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :first_essence, :second_essence, :first_num, :second_num, 
                    :private_roll

      def parse_args

        args = cmd.parse_args(ArgParser.arg1_slash_optional_arg2)

        return if not args.arg1
        
          self.first_essence = list_arg(args.arg1,"=").at(0)
          self.first_num = list_arg(args.arg1,"=").at(1)
          
        if args.arg2
          self.second_essence = list_arg(args.arg2,"=").at(0)
          self.second_num = list_arg(args.arg2,"=").at(1)
        end

     

      end

     def required_args
        [ self.first_num, self.first_essence ]
     end
      
      def handle
        client.emit_success "First Essence :" + self.first_essence
        client.emit_success "First num :" + self.first_num.to_s


        client.emit_success "Second Essence :" + self.second_essence if self.second_essence
        client.emit_success "Second num :" + self.second_num.to_s if self.second_essence

      end
    end
  end
end