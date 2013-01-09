
CarrierWave.configure do |config|
      config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => 'AKIAJU4IAXMS575N42IA',
        :aws_secret_access_key  => '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',
      }

      config.fog_directory  = ApplicationController.s3_bucket                     # required
      config.fog_public     = true                                   # optional, defaults to true
      config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
      config.asset_host = "http://#{config.fog_directory}.s3.amazonaws.com"
    
end


