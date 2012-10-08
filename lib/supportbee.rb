class SupportBee
  class InvalidAuthToken < ::StandardError; end

  def initialize(auth_token)
    raise InvalidAuthToken if auth_token.blank?    
  end  
end
