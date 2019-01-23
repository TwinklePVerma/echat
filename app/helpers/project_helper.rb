module ProjectHelper
  
  def generate_secret_key(public_key)
    secret_key = SecureRandom.hex(10)
    obj = Crypt.new("#{public_key}#{Rails.application.secrets.secret_key_base}")
    obj.encrypt(secret_key)
  end
  
end
