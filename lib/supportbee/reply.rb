module SupportBee
  class Reply < Resource
    def refresh
      raise NotImplementedError.new('A reply can be refreshed only through a ticket. Check Out Ticket#refresh_reply(reply_id)')
    end
  end
end
