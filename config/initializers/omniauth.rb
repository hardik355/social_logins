Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['419579775647987'], ENV['8107e844d0dcfb8c56e215a1cbc37637']
  provider :google_oauth2, ENV['339272304789-n2km49606430j1oco2dh23j4m2l7v9ll'], ENV['JGx84GNlDta7rV4Y-PEz6hnM']

end