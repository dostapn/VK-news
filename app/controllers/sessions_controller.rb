class SessionsController < ApplicationController
  def new
    srand
    session[:state] = Digest::MD5.hexdigest(rand.to_s)
    @vk = VkontakteApi.authorization_url(scope: [:friends, :video, :messages, :notify], state: session[:state])
  end

  def create
    @vk=VK.new(params[:username], params[:password], app_id: VkontakteApi.app_id)
    if @vk.get_token
      session[:token], session[:vk_id]=@vk.access_token, @vk.user_id
      redirect_to home_path
    else
      render 'new'
    end
  end
end
