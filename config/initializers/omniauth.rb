Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '206242543138832', 'a9929255ca1652eab82a8e2fc004e12b'
end
