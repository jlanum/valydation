push_configs = {
  'development' => {
    'certificate' => Rails.root.to_s + "/certs/MySaleTableDev.pem"
  },
  'production' => {
    'certificate' => Rails.root.to_s + "/certs/MySaleTableDev.pem"
  }
}

GrocerConfig = push_configs[Rails.env]
