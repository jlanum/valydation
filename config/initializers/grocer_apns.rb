push_configs = {
  'development' => {
    'certificate' => Rails.root.to_s + "/certs/MSTDevCert.pem"
  },
  'production' => {
    'certificate' => Rails.root.to_s + "/certs/MSTProdCert.pem"
  }
}

GrocerConfig = push_configs[Rails.env]
