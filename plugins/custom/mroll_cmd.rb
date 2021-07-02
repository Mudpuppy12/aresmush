module AresMUSH
    module Custom
      class MrollCmd
        include CommandHandler
        
        def parse_args
         self.mroll = trim_arg(cmd.args)
        end
  
        def handle
          client.emit_success "Mroll executed"
        end
      end
    end
  end
  