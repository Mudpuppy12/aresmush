module AresMUSH
  module Renown

     def self.calculate_gained (name)
       points = 0
       char = Character.find_one_by_name name
        if !char
          return nil
        end
        char.gained.each do |c|
          points = points + c.value
        end
        return points
     end

     def self.calculate_gained_time (name,days)
       points = 0
       char = Character.find_one_by_name name
        if !char
          return nil
        end
        now = Date.today
        start_date = (now - days)
        char.gained.each do |c|
          if (c.created_at >= start_date)
              points = points + c.value
          end
        end
        return points
     end

     def self.add_entry(name, title, value, adminname)
        char = Character.find_one_by_name name
        if !char 
          return nil
        end
        RenownEntry.create(character: char, title: title, value: value, creator: adminname)
     end

     def self.clear_renown(char)
        entries = char.gained
        entries.each do |e|
           e.title = nil
           e.creator = nil
           e.value = 0
           e.delete
        end
     end

     def self.prettify(amount)
         if !amount
             return "Not set."
         else
           rev = amount.to_s.reverse
           ar = rev.scan(/.{3}/)
           len_last = amount.to_s.length % 3
           last = amount.to_s.slice(0,len_last).reverse
           if (last.length > 0)
              ar = ar << last
           end
           string = ar.join(",").reverse
        end
        return string
     end

     def self.plural(noun)
       if (noun[-1] == "y")
          len = noun.length
          return noun[0..(len-2)] + "ies"
       else
          return noun + "s"
       end
     end

    def self.get_renown_chars
      classes = Global.read_config("renown", "renown_members")
      if (classes == {})
         chars = Chargen.approved_chars.sort_by { |c| c.name}
      else
         chars = []
         classes.each do |t|
            chars = chars | Chargen.approved_chars.select { |c| c.groups[t["group"]] == t["value"] }
         end
      end
      chars
    end

    def self.renown_orgs(orgname)
      orgs = []
      chars = Renown.get_renown_chars
      chars.each do |c|
         org = c.groups[orgname]
         if (org != "")    # quick patch of an error
            orgs.push org
         end
      end 
      orgs.uniq.sort
    end

    def self.calculate_total(type,name)
       total = 0
       chars = Chargen.approved_chars.select {|c| c.groups[type] == name }
       chars.each do |c|
         total = total + Renown.calculate_gained(c.name)
       end
       total
    end

    def self.get_top_list(type,limit)
       list = []
       if (type == "char")
          chars = Renown.get_renown_chars
          chars.each do |c|
             list << { :name=>c.name, :total=>Renown.calculate_gained(c.name)}
          end
       elsif ( type == {} )
          list = []
       else 
          orgs = Renown.renown_orgs(type)
          orgs.each do |h|
             list << { :name=>h, :total=>Renown.calculate_total(type,h)}
          end
       end
       list = list.sort_by { |entry| entry[:total]}.reverse
       if (limit > 0) && (list.length > limit)
          list = list[0..(limit-1)]
       end
       list.each do |l|
          l[:total] = Renown.prettify(l[:total])
       end
       return list
    end

    def self.get_max_renown_char(days)
       max = 0
       name = "Nobody"
       chars = Chargen.approved_chars
       chars.each do |c|
           renown = Renown.calculate_gained_time(c.name,days)
           if (renown > max)
              max = renown
              name = c.name
           end
       end
       return name
    end

    def self.general_field(char, field_type, value)
      case field_type
      when 'name'
        Demographics.name_and_nickname(char)
      when 'rank'
        char.ranks_rank
      when 'group'
        char.group(value)
      when 'handle'
        char.handle ? "@#{char.handle.name}" : ""
      when 'last_on'
        char.last_on
      else 
        nil
      end
    end

  end
end
