module AresMUSH
  module FS3Combat
    class CombatJoinCmd
      include CommandHandler
      include NotAllowedWhileTurnInProgress
      
      attr_accessor :names, :num, :combatant_type
      
      def crack!
        if (cmd.args =~ /=/)
          cmd.crack_args!(ArgParser.arg1_equals_arg2_slash_optional_arg3)
          self.names = cmd.args.arg1 ? cmd.args.arg1.split(" ").map { |n| titleize_input(n) } : nil
          self.num = trim_input(cmd.args.arg2)
          self.combatant_type = titleize_input(cmd.args.arg3)
        else
          cmd.crack_args!(ArgParser.arg1_slash_optional_arg2)
          self.names = [ enactor_name ]
          self.num = titleize_input(cmd.args.arg1)
          self.combatant_type = titleize_input(cmd.args.arg2)
        end
      end

      def required_args
        {
          args: [ self.names, self.num ],
          help: 'combat'
        }
      end
      
      def check_commas
        return t('fs3combat.dont_use_commas_for_join') if self.names.any? { |n| n.include?(",")}
        return nil
      end
      
      def check_type
        return nil if !self.combatant_type       
        return t('fs3combat.invalid_combatant_type') if !FS3Combat.combatant_types.include?(self.combatant_type)
        return t('fs3combat.use_vehicle_type_cmd') if FS3Combat.passenger_types.include?(self.combatant_type)
        return nil
      end
      
      def handle
        combat = FS3Combat.find_combat_by_number(client, self.num)
        return if !combat
        
        type = self.combatant_type || Global.read_config("fs3combat", "default_type")
        
        self.names.each_with_index do |n, i|
          FS3Combat.join_combat(combat, n, type, enactor, client)
        end
      end
    end
  end
end