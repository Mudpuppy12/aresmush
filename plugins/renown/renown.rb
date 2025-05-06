$:.unshift File.dirname(__FILE__)

module AresMUSH
     module Renown

    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.achievements
      Global.read_config("renown", "achievements")
    end

    def self.fields
      Global.read_config("renown", "renown_fields")
    end

    def self.visible
      Global.read_config("renown", "visible")
    end

    def self.title
      Global.read_config("renown", "renown_title")
    end

    def self.group
      Global.read_config("renown", "renown_group")
    end

    def self.standard_types
      Global.read_config("renown", "standard_types")
    end

    def self.shortcuts
      Global.read_config("renown", "shortcuts")
    end

    def self.get_cmd_handler(client, cmd, enactor)
      case cmd.root
      when "renown"
        case cmd.switch
        when "view"
          return RenownViewCmd
        when "add"
          return RenownAddCmd
        when "all"
          return RenownAllCmd
        when "reset"
          return RenownResetCmd
        when "group"
          return RenownViewGroupCmd
        when "top"
          return RenownTopCmd
        end
      end
    end

    def self.get_event_handler(event_name)
      case event_name
      when "CronEvent"
        return CronEventHandler
      end
    end

    def self.get_web_request_handler(request)
       case request.cmd
         when "renownAddEntry"
           return RenownAddEntryRequestHandler
         when "renownListFull"
           return RenownTotalRequestHandler
         when "renownOrg"
           return RenownOrgRequestHandler
         when "renownOrgs"
           return RenownOrgsRequestHandler
         when "renownResetAll"
           return RenownResetAllRequestHandler
         when "renownTop"
           return RenownTopRequestHandler
         end
    end

  end
end
