# encoding: utf-8

class GpgUploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes

  # Choose what kind of storage to use for this uploader:
  # storage :file
  if Rails.env.test?
    storage :file
  else
    storage :fog
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/users/#{mounted_as}/#{model.id}"
  end
  
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
  
  def extension_white_list
    %w(asc key gpg txt)
  end

  def filename
     @name ||= "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end
