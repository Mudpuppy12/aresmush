module AresMUSH
  module Renown
    class CronEventHandler
     
      def on_event(event)
        config = Global.read_config("renown", "cron_regular_check")
        if Cron.is_cron_match?(config, event.time)
          Global.logger.debug "Checking current renown."
          days = Global.read_config("renown", "cron_renown_days")
          message_title = Global.read_config("renown", "cron_message_title")
          name = Renown.get_max_renown_char(days)
          if (name != "Nobody")
            points = Renown.prettify(Renown.calculate_gained_time(name,days))
            title = message_title + ": " + name
            Forum.system_post(
              Global.read_config("renown", "cron_message_category"),
              title, 
              t('renown.regular_renown_message', :name => name, :points => points, :days => days, :renown_name => Renown.title.downcase ))
            target = Character.find_one_by_name(name)
            Achievements.award_achievement(target, "renown_leading")
          end
        end
      end 

    end
  end
end
