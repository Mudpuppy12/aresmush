module AresMUSH
  module Renown

    def self.build_web_renown_data(char, viewer)
      builder = WebRenownGainedDataBuilder.new
      builder.build(char, viewer)
    end

  end
end
