module AresMUSH
  module Custom
    class MrollCmd
      include CommandHandler
      
      attr_accessor :first_essence, :second_essence, :first_num, :second_num, 
                    :private_roll

      def parse_args

        args = cmd.parse_args(ArgParser.arg1_slash_arg2)
        
        if args.arg2
          client.emit_success "Yes"
        end
        
        
        self.first_essence = list_arg(args.arg1,"=").at(0)
        self.first_num = list_arg(args.arg1,"=").at(1)

        # help

        client.emit_success "First Essence :" + self.first_essence
        client.emit_success "First num :" + self.first_num.to_s

       
        #if args.arg2
        #  second_essence = args.arg2.parse_args(/(?<essence>[\S]*)[=](?<num>[\d]+$)/)
        #end

        #self.first_num = args.arg1.num.to_i
        #self.first_essence = args.arg1.essence

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