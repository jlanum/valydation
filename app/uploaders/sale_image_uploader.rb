# encoding: utf-8

CarrierWave.configure do |config|
      config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => 'AKIAJU4IAXMS575N42IA',
        :aws_secret_access_key  => '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',
      }

      config.fog_directory  = ApplicationController.s3_bucket                     # required
      config.fog_public     = true                                   # optional, defaults to true
      config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

class SaleImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog

  include CarrierWave::MimeTypes

  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
  #  "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end
  #

  version :feed_large_2x do
    process :resize_to_fill => [640, 640]
    process :set_content_type
  end

  version :feed_large do
    process :resize_to_fill => [320, 320]
    process :set_content_type
  end

  version :feed_2x do
    process :resize_to_fill => [460, 460]
    process :set_content_type
  end

  version :feed, :from_version => :feed_2x do
    process :resize_to_fill => [230,230]
    process :set_content_type
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
