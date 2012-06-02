# Helper methods defined here can be accessed in any controller or view in the application

MarkyTweet.helpers do
  def trends
    TwitterProxy.global_trends[:results].map { |e|
      {
        :name => "#{e.name}#{e.promoted_content ? '(promoted)' : ''}",
        :link => url( "/?query=" + TwitterProxy.normalise_n_escape( e.name ) )
      }
    }
  end
end
