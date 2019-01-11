Swagger::Docs::Config.base_api_controller = ActionController::API

class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "apidocs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  "1.0" => {
    :api_extension_type => :json,
    :api_file_path => "public/apidocs",
    :base_path => "http://localhost:4000",
    :clean_directory => true,
    :attributes => {
      :info => {
        "title" => "ECHAT",
        "description" => "Chating library",
        "contact" => "tverma@isystango.com"
       }
     }
  }
})
