module AresMUSH
  module Renown
    class RenownOrgsRequestHandler
      def handle(request)
        orgs = ( Renown.group != {} ) ? Renown.renown_orgs(Renown.group) : []
      end
    end
  end
end
