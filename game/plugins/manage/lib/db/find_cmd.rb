module AresMUSH
  module Manage
    class FindCmd
      include CommandHandler

      attr_accessor :search_class, :name

      def crack!
        cmd.crack_args!(ArgParser.arg1_equals_optional_arg2)
        
        self.search_class = cmd.args.arg1 ? trim_input(cmd.args.arg1).titleize : nil
        self.name = trim_input(cmd.args.arg2)
      end
      
      def required_args
        {
          args: [ self.search_class ],
          help: 'find'
        }
      end
      
      def handle
        begin
          c = AresMUSH.const_get(self.search_class)
          
          if (!Manage.can_manage_object?(enactor, c.new))
            client.emit_failure t('dispatcher.not_allowed')
            return
          end
          
          if (!self.name)
            objects = c.all
          else
            objects = c.all.select { |o| o.name_upcase =~ /#{self.name.upcase}/ }
          end
        rescue
          client.emit_failure t('manage.invalid_search_class')
          return
        end
          
        objects = objects.sort { |a,b| a.name_upcase <=> b.name_upcase}
        objects = objects.map { |r| "#{r.id.ljust(4)} #{r.name}"}
        client.emit BorderedDisplay.list(objects, t('manage.find_results'))
      end
    end
  end
end
