module AresMUSH
  module Renown
    class WebRenownGainedDataBuilder
      def build(char, viewer)
        if (!viewer)
          return nil
        end

        is_owner = (viewer && viewer.id == char.id)
        is_admin = viewer.is_admin?
        is_visible = Renown.visible

        show_renown = is_visible || is_admin || is_owner
        
        if show_renown
           return build_renown_data(char)
        else
           return nil
        end
      end

     def build_renown_data(char)
        gained_list = char.gained
        if (gained_list == nil)
           return nil
        end
        gained_list.map { |n|
        {
           title: n.title,
           value: Renown.prettify(n.value),
           created_at: prettify_datetime(n.created_at),
           adminname: n.creator
        }}
     end

    def prettify_datetime(datetime)
       pretty = datetime.to_s[0..9] + ", " + datetime.to_s[11..15]
       return pretty
    end

    end
  end
end
