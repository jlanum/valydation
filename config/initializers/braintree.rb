braintree_env = :sandbox

if braintree_env == :sandbox
  #max's sandbox account
  Braintree::Configuration.environment = :sandbox
  Braintree::Configuration.merchant_id = "c4s7qfk7mhhvcthy"
  Braintree::Configuration.public_key = "52msgwgddhpqws93"
  Braintree::Configuration.private_key = "8229f4ec35c427be42724c4aedc37af6"
else
  #mst prod account
  Braintree::Configuration.environment = :production
  Braintree::Configuration.merchant_id = "v26v8r9xmv32qc37"
  Braintree::Configuration.public_key = "y5p4pgnc4xzyxsy7"
  Braintree::Configuration.private_key = "99fd7ac79eab875f2b9511590c43eee9"
end


