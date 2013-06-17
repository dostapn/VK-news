class MainController < ApplicationController
  def index
    vk=VkontakteApi::Client.new(session[:token])
    @user=vk.users.get(uid: session[:vk_id], fields: [:screen_name, :photo]).first
    @newsfeeds=vk.newsfeed.get(filters: [:post, :photo, :photo_tag, :wall_photo],count: 3)
    @offset=@newsfeeds.new_offset + 1
    @friends=vk.friends.get(fields: [:screen_name,:photo,:rate,:education]).sort_by{|x| [-x.online,-x.rate.to_i]}
  end

  def update_news
    vk=VkontakteApi::Client.new(session[:token])
    @newsfeeds=vk.newsfeed.get(filters: [:post, :photo, :photo_tag, :wall_photo],count: 3, offset: params[:offset])
    @offset=@newsfeeds.new_offset
    render :action => :index, :layout => false
  end

  def search
    vk=VkontakteApi::Client.new(session[:token])
    @results=vk.newsfeed.search(q: params[:key])

  end
end
