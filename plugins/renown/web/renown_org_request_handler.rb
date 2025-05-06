module AresMUSH
  module Renown
    class RenownOrgRequestHandler
      def handle(request)

        fields = Global.read_config("renown", "web_renown_total_fields")
        titles = fields.map { |f| f['title'] }
        titles << Renown.title
        org = request.args['org']

        chars = Chargen.approved_chars.select {|c| c.groups[Renown.group] == org }
        chars = chars.sort_by { |c| c.name}

        people = []
        
        chars.each do |c|
          char_data = {}
          char_data['char'] = {
               name: c.name,
               icon:  Website.icon_for_char(c)  }
          fields.each do |field_config|
            field = field_config["field"]
            title = field_config["title"]
            value = field_config["value"]

            char_data[title] = Renown.general_field(c, field, value)
          end
          char_data['Renown'] = Renown.prettify(Renown.calculate_gained(c.name))
          
          people << char_data
        end

        total = Renown.prettify(Renown.calculate_total(Renown.group,org))
        
        orgtype = Renown.group.titleize

        renown_title = Renown.title

        {
          titles: titles,
          people: people,
          renown: total,
          orgtype: orgtype, 
          title: renown_title
        }
      end
    end
  end
end
