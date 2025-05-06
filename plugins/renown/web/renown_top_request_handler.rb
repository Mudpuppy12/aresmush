module AresMUSH
  module Renown
    class RenownTopRequestHandler
      def handle(request)

        topchars = Renown.get_top_list("char",10)
        group = Renown.group
        toporgs = (group != {} ) ? Renown.get_top_list(group,10) : nil
        title = Renown.title
        org_header = (group != {} ) ? Renown.plural(Renown.group).titleize : ""
        show_org_links = Global.read_config("renown","org_links")
        org_page_prefix = Global.read_config("renown","org_page_prefix")
        org_page_prefix = (org_page_prefix == {}) ? "" : org_page_prefix
        org_page_postfix = Global.read_config("renown","org_page_postfix")
        org_page_postfix = (org_page_postfix == {}) ? "" : org_page_postfix

        {
          chars: topchars,
          orgs: toporgs,
          renown_title: title,
          orgname: org_header,
          show_links: show_org_links,
          org_prefix: org_page_prefix,
          org_postfix: org_page_postfix
        }
      end

    end
  end
end
