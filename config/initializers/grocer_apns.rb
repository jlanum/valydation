push_configs = {
  'development' => {
    'certificate' => Rails.root.to_s + "/certs/MySaleTableDev.pem"
  },
  'production' => {
    'certificate' => Rails.root.to_s + "/certs/MySaleTableProd.pem"
  }
}

GrocerConfig = push_configs[Rails.env]
