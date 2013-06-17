class VK
  attr_reader :access_token,:user_id

  def initialize(login, password, options={})
    @login, @password=login, password
    @agent=Mechanize.new
    #https://oauth.vk.com/authorize?response_type=code&client_id=3202795&scope=friends%2Coffline%2Cnotify%2Cwall&state=1638a0934ffb1f36e4a65589e761c084&redirect_uri=http%3A%2F%2Foauth.vk.com%2Fblank.html
    @app_id=options.delete(:app_id)
    @redirect_uri='http://oauth.vk.com/blank.html'
    @settings=[:friends, :video, :offline, :notify, :wall, :photos, :notes]

  end


  def authorize
    login_page=@agent.get('http://vk.com')
    login_page.forms.inspect
    login_page.forms.first.email = @login
    login_page.forms.first.pass = @password
    @agent.submit login_page.forms.first
  end

  def authorized?
    @agent.cookies.any? { |cookie| cookie.name == 'remixsid' }
  end

  def get_token
    authorize unless authorized?
    if authorized?
      # application authorize
      params = {:client_id => @app_id,
                :scope => @settings.join(','),
                :redirect_uri => @redirect_uri,
                :response_type => :token}

      page = @agent.get 'https://oauth.vk.com/authorize?' + (params.map { |k, v| "#{k}=#{v}" }).join('&')
      page=@agent.submit page.forms.first
      reg = /\Ahttps:\/\/oauth\.vk\.com\/blank\.html\#access_token=(\w+)&.*&user_id=(\d+).*\z/
      r = page.uri.to_s.match(reg)
      @access_token,@user_id=r[1,2]
      #p @access_token,@user_id
      return @user_id
    end
    nil
  end
end
