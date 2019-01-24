module CustomEncDec
  class << self
    # Encrypts the plain_text with the provided key
    def encrypt(plain_text, key)
      ::CustomEncDec::CustomEncDec.new(key).encrypt(plain_text)
    end

    # Decrypts the cipher_text with the provided key
    def decrypt(cipher_text, key)
      ::CustomEncDec::CustomEncDec.new(key).decrypt(cipher_text)
    end

    # Generates a random key of the specified length in bits
    # Default format is :plain
    def generate_key(length = 256)
      ::CustomEncDec::CustomEncDec.new("").random_key(length)
    end
  end

  class CustomEncDec
    attr :key

    def initialize(key)
      @key = key
      @characters = [" ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".",
                     "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=",
                     ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                     "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[",
                     "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                     "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    end

    # Encrypts
    def encrypt(plain_text)
      encryption_algo(plain_text, shift_by)
    end

    # Decrypts
    def decrypt(cipher_text)
      decryption_algo(cipher_text, shift_by)
    end

    # Generate a random key
    def random_key(length=256)
      _random_seed.unpack('H*')[0][0..((length/8)-1)]
    end

    private

      # Generates a random seed value
      def _random_seed(size=32)
        if defined? OpenSSL::Random
          return OpenSSL::Random.random_bytes(size)
        else
          chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
          (1..size).collect{|a| chars[rand(chars.size)] }.join
        end
      end

      def shift_by
        @key.sum % 26
      end

      def encryption_algo(str, n)
        enc = str.chars.map {|x| @characters.include?(x) ? @characters[(@characters.find_index(x) + n) % 91] : x}.join
        Base64.encode64(enc).chomp
      end

      def decryption_algo(str, n)
        dec = Base64.decode64(str)
        dec.chars.map {|x| @characters.include?(x) ? @characters[(@characters.find_index(x) - n + 91) % 91] : x}.join
      end
  end
end



# Client side CustomEncDnc

# var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9+/=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/rn/g,"n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}};
# var characters = [" ", "!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".",
#                   "/", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=",
#                   ">", "?", "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
#                   "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[",
#                   "\\", "]", "^", "_", "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
#                   "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
# var CustomEncDec = {
#   encrypt:function(plain_text, key){
#     var cipher_text = '';
#     for (var i = 0; i < plain_text.length; ++i) {
#       var x = plain_text[i];
#       if(characters.includes(x)) {
#         cipher_text += characters[(characters.indexOf(x) + CustomEncDec.shiftBy(key)) % 91];
#       } else {
#         cipher_text += x;
#       }
#     }
#     return Base64.encode(cipher_text);
#   },
#   decrypt:function(cipher_text, key){
#     cipher_text = Base64.decode(cipher_text);
#     var plain_text = '';
#     for (var i = 0; i < cipher_text.length; ++i) {
#       var x = cipher_text[i];
#       if(characters.includes(x)) {
#         plain_text += characters[(characters.indexOf(x) - CustomEncDec.shiftBy(key)
#  + 91) % 91];
#       } else {
#         plain_text += x;
#       }
#     }
#     return plain_text;
#   },
#   shiftBy:function(key){
#     sum = 0;
#     for (var i = 0; i < key.length; i++) {
#       sum += key.charCodeAt(i);
#     }
#     return (sum % 26);
#   }
# }
