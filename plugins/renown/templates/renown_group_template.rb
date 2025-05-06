module AresMUSH
  module Renown
    class RenownGroupTemplate < ErbTemplateRenderer
      
      attr_accessor :chars
      
      def initialize(chars,org)
        @chars = chars
        @org = org
        super File.dirname(__FILE__) + "/renown_group.erb"
      end

      def org_title
         title = Renown.group.titleize + " " + @org + " - " + Renown.title
         return title
      end
      
      def org_chars
        list = []
        @chars.each do |c|
          list << "%r#{left(c[0],30)} #{left(c[1],19)} #{right(Renown.prettify(c[2]),15)}"
        end
        list
      end

      def org_total
        type = Global.read_config("renown","renown_group")
        total = Renown.calculate_total(type,@org)
        title = "Total"
        line = "#{left(title,50)} #{right(Renown.prettify(total),15)}"
      end

    end
  end
end
