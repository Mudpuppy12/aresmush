module AresMUSH
  module Renown
    class RenownAllTemplate < ErbTemplateRenderer
      
      attr_accessor :chars
      
      def initialize(chars)
        @chars = chars
        super File.dirname(__FILE__) + "/renown_all.erb"
      end

      
      def all_chars
        list = []
        chars.each do |c|
          list << "#{left(c.name,26)} #{left(c.groups[Renown.group],19)} #{left(c.ranks_rank,15)} #{right(Renown.prettify(Renown.calculate_gained(c.name)),15)}%r"
        end
        return list
      end

      def title
        return Renown.title + " - All Characters"
      end

      def titles
        return "#{left("Name",26)} #{left(Renown.group.titleize,19)} #{left("Rank",15)} #{right("Points",15)}"
      end

    end
  end
end
