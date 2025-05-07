module AresMUSH
  module Renown
    class RenownAllTemplate < ErbTemplateRenderer
      
      attr_accessor :chars
      
      def initialize(chars)
        @chars = chars
        super File.dirname(__FILE__) + "/renown_all.erb"
      end

      def group_line(char)
         "#{left(char.name,26)} #{left(char.groups[Renown.group],19)} #{left(char.ranks_rank,15)} #{right(Renown.prettify(Renown.calculate_gained(char.name)),15)}%r"
      end

      def no_group_line(char)
         "#{left(char.name,26)} #{right(Renown.prettify(Renown.calculate_gained(char.name)),15)}%r"
      end

      
      def all_chars
        list = []
        chars.each do |c|
          char_entry = (Renown.group == {}) ? no_group_line(c) : group_line(c)
          list << char_entry
        end
        return list
      end

      def title
        return Renown.title + " - All Characters"
      end

      def titles
        return "#{left("Name",26)} #{right("Points",15)}" if (Renown.group == {}) 
        return "#{left("Name",26)} #{left(Renown.group.titleize,19)} #{left("Rank",15)} #{right("Points",15)}"
      end

    end
  end
end
