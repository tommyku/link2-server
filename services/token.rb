require 'jwt'
require 'jwe'

class Token
  attr_reader :payload

  def initialize(payload = {})
    @payload = {}.tap do |h|
      payload.each_key { |key| h[key.to_sym] = payload[key] }
    end
    @payload[:iss] = payload[:iss] || 'link2'
    @payload[:exp] = payload[:exp] || exp
  end

  def encode
    jwt_token = JWT.encode(@payload, ENV['JWT_ENCODING_KEY'], 'HS512')
    JWE.encrypt(jwt_token,
                ENV['JWE_ENCRYPTION_KEY'],
                alg: 'dir',
                enc: 'A256CBC-HS512')
  end

  def self.decode(token)
    jwt_token = JWE.decrypt(token, ENV['JWE_ENCRYPTION_KEY'])
    begin
      payload, = JWT.decode(jwt_token, ENV['JWT_ENCODING_KEY'])
      return Token.new(payload)
    rescue JWT::DecodeError
      return false
    end
  end

  def expired?
    Time.now > Time.at(@payload[:exp].to_i) unless @payload[:exp].nil?
  end

  def renew!
    @payload[:exp] = exp
  end

  private

  def exp
    Time.now.to_i + 7 * 86_400
  end
end
