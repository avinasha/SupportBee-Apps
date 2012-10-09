module SupportBee
  class Comment < Resource
    def refresh
      raise NotImplementedError.new('A comment cannot be refreshed')
    end
  end
end

