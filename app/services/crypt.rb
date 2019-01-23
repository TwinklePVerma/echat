class Crypt

  def initialize key
    @crypt = ActiveSupport::MessageEncryptor.new(key)
  end

  def encrypt secret_key
    encrypted_data = @crypt.encrypt_and_sign(secret_key)
  end

  def decrypt encrypted_data
    decrypted_back = @crypt.decrypt_and_verify(encrypted_data)
  end
end