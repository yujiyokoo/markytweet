MarkyTweet.controllers :home do
  register Padrino::Cache
  enable :caching

  layout :app
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  get :index, :map => '/', :cache => true do
    expires_in 300
    @title = 'Home'
    render 'home/index'
  end
  
  get :about, :map => '/about', :cache => true do
    expires_in 300
    render 'home/about'
  end

  get :fineprint, :map => '/fineprint', :cache => true do
    expires_in 300
    render 'home/fineprint'
  end
end
