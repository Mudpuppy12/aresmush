module AresMUSH
  module Renown
    class RenownResetAllRequestHandler
      def handle(request)
        enactor = request.enactor

        error = Website.check_login(request, true)
        return error if error

        request.log_request

        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end

        chars = Chargen.approved_chars

        chars.each do |c|
           Renown.clear_renown(c)
        end

        Global.logger.info "All renown has been cleared for the current season (triggered by #{enactor.name})."
      end
    end
  end
end
