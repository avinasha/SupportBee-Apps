module SupportBee
  class Assignment < Resource
    def refresh
      raise NotImplementedError.new('An Assignment cannot be refreshed')
    end
  end
end
