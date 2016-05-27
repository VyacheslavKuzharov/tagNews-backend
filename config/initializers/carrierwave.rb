CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY']||"AKIAJDX4ECXMMRJJH5RA",
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']||"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"
  }

  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory  =  ENV['AWS_BUCKET']||"tagnews"
end