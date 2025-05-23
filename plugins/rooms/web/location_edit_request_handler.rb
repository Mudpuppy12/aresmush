module AresMUSH
  module Rooms
    class LocationEditRequestHandler
      def handle(request)
        id = request.args['id']
        name = request.args['name']
        descs = request.args['descs']
        summary = request.args['summary']
        area_id = request.args['area_id']
        icon_type = request.args['icon_type']
        owner_names = request.args['owners'] || []
        enactor = request.enactor
                
        error = Website.check_login(request)
        return error if error
        
        request.log_request
        
        room = Room[id]
        if (!room)
          return { error: t('webportal.not_found') }
        end
        
        if (!(room.room_owners.include?(enactor) || Rooms.can_build?(enactor)))
          return { error: t('dispatcher.not_allowed') }
        end
        
        if (!area_id.blank?)
          area = Area[area_id]
          if (!area)
            return { error: t('webportal.not_found') }
          end
        else
          area = nil
        end
        
        if (name.blank?)
          return { error: t('webportal.missing_required_fields', :fields => "name") }
        end

        owner_names = owner_names.map { |p| p.upcase }
        room.room_owners.each do |p|
          if (!owner_names.include?(p.name_upcase))
            room.room_owners.delete p
          end
        end
        owner_names.each do |p|
          owner = Character.find_one_by_name(p.strip)
          if (owner)
            room.room_owners.add owner
          end
        end

        room.update(name: name, 
           area: area, 
           shortdesc: Website.format_input_for_mush(summary),
           room_icon: icon_type.blank? ? nil : icon_type)
           
         Describe.save_web_descs(room, descs)
        
        {}
      end
    end
  end
end


