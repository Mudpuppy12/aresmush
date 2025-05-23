module AresMUSH
  module Describe
    # Template for a room.
    class RoomTemplate < ErbTemplateRenderer
             
      attr_accessor :room
                     
      def initialize(room, enactor)
        @room = room
        @enactor = enactor
        super File.dirname(__FILE__) + "/room.erb"        
      end
      
      def is_foyer
        @room.is_foyer?
      end
      
      # List of all exits in the room.
      def exits
        if (@room.is_foyer?)
          non_foyer_exits
        else
          @room.exits.sort_by(:name, :order => "ALPHA")
        end
      end
      
      # List of online characters, sorted by name.      
      def online_chars
        chars = @room.characters.select { |c| Login.is_online?(c) }
        if (@room.scene)
          web_participants = @room.scene.participants.select { |c| Login.find_web_client(c) }
          chars.concat(web_participants)
        end
        chars.uniq.sort_by { |c| c.name }
      end
      
      # Available detail views.
      def details
        @room.details.empty? ? nil : @room.details.keys.sort.join(", ")
      end
      
      def logging_enabled
        @room.logging_enabled?
      end
      
      # Short IC date/time string
      def ic_time
        ICTime.ic_datestr ICTime.ictime
      end
      
      def area
        @room.area_name
      end
      
      def area_and_grid
        room_grid = grid
        grid ? "#{area} #{grid}" : area
      end
      
      # Room grid coordinates, e.g. (1,2)
      def grid
        @room.grid_marker
      end
      
      def web_watchers
        return nil if !@room.scene || @room.scene.watchers.empty?
        @room.scene.watchers.map { |c| c.name }.join(", ")
      end
      
      def description
        @room.expanded_desc
      end
      
      def ooc_time
        OOCTime.local_short_timestr(@enactor, Time.now)
      end
      
      def foyer_exits
        @room.exits.select { |e| e.dest && e.name.is_integer? }.sort_by { |e| e.name }
      end
      
      def non_foyer_exits
        @room.exits.select { |e| !e.name.is_integer? || !e.dest }.sort_by { |e| e.name }
      end
      
     
      def foyer_status(e, i)
        chars = e.dest.characters
        if (!e.lock_keys.empty?)
          status = t('describe.foyer_room_locked')
        elsif (chars.count == 0)
          status = t('describe.foyer_room_free')
        elsif (chars.select { |c| Login.find_game_client(c) }.count > 0 )
          status = t('describe.foyer_room_in_use')
        else
          status = t('describe.foyer_room_occupied')
        end
        linebreak = i % 2 == 0 ? "%R" : ""
        room_name = "#{exit_destination(e)} (#{status})"
        "#{linebreak}%xh#{exit_name(e)}%xn #{left(room_name,29)}"
      end
      
      def char_shortdesc(char)
        char.shortdesc ? "- #{char.shortdesc}" : ""
      end
      
      def char_tag(char)
        tag = ""
        colors = Global.read_config("describe", "tag_colors") || {}
        tag << "#{colors['web']}#{Website.web_char_marker}%xn " if Login.is_portal_only?(char)
        tag << "#{colors['admin']}[#{t('describe.admin_tag')}]%xn " if char.is_admin?
        tag << "#{colors['beginner']}[#{t('describe.beginner_tag')}]%xn " if char.is_beginner?
        return tag
      end
      
      def char_name(char)
        Demographics.name_and_nickname(char)
      end
      
      # Shows the AFK message, if the player has set one, or the automatic AFK warning,
      # if the character has been idle for a really long time.
      def char_afk(char)
        client = Login.find_game_client(char)
        return nil if !client
        idle_secs = client.idle_secs
        idle_str = TimeFormatter.format(idle_secs)
        if (char.is_afk?)
          afk_message = char.afk_display
          if (afk_message)
            "%xr[#{t('describe.afk')}:#{idle_str}%xH #{afk_message}]%xn "
          else
            "%xr[#{t('describe.afk')}:#{idle_str}]%xn "
          end
        elsif (client && Status.is_idle?(client))
          "%xy%xh[#{idle_str}]%xn "
        elsif (Global.read_config('describe', 'always_show_idle_in_rooms'))
          "%xh%xx[#{idle_str}]%xn "
        else
          ""
        end
      end
      
      def exit_name(e)
        Describe.format_exit_name(e)
      end
      
      def exit_destination(e)
        locked =  e.allow_passage?(@enactor) ? "" : "%xr*#{t('describe.locked')}*%xn "
        if (e.dest)
          name = e.shortdesc ? e.shortdesc : e.dest.name
        else
          name = t('describe.nowhere')
        end
        "#{locked}#{name}"
      end
      
      def exit_linebreak(i)
        i % 2 == 0 ? "%r" : ""
      end
      
      def scene_url
        @room.scene ? @room.scene.live_url : ""
      end
    end
  end
end