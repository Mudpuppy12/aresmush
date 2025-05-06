module AresMUSH
  module Renown
    class RenownAddEntryRequestHandler
      def handle(request)
        enactor = request.enactor
        char = Character.find_one_by_name request.args['name']
        title = request.args['title']
        points = request.args['points'].to_i
        type = request.args['type']

        error = Website.check_login(request, true)
        return error if error

        request.log_request

        if (!char)
          return { error: t('webportal.not_found') }
        end

        if (!enactor.is_admin?)
          return { error: t('dispatcher.not_allowed') }
        end

        Renown.add_entry(char.name, title, points, enactor.name)
        Global.logger.info "A new renown entry has been added for #{char.name}: #{title} - #{points} points (triggered by #{enactor.name})."
        {
            name: char.name
        }
      end
    end
  end
end
