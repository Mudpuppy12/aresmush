module AresMUSH
  module Renown
    class RenownTemplate < ErbTemplateRenderer
      
      attr_accessor :char
      
      def initialize(char)
        @char = char
        super File.dirname(__FILE__) + "/renown.erb"
      end
      
      def title
        center( @char.name + "'s " + Renown.title + " in the Current Season", 78 )
      end 

      def titles
        "#{left("Reason",35)} #{right("Points",10)}   #{left("Awarded on",16)}   #{left("by",10)}%r"
      end

      def gained
        list = []
        @char.gained.each do |l|
          list << "%r#{left(l.title,35)} #{right(Renown.prettify(l.value),10)}   #{left(l.created_at,16)}   #{left(l.creator,10)}"
        end
        list
      end

      def gained_total
        total = Renown.prettify(Renown.calculate_gained(char.name))
        title = "Total"
        line = "#{left(title,35)} #{right(total,10)}"
      end

    end
  end
end
