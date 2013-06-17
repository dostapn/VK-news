module ApplicationHelper
  def vk_url(user)
    "http://vk.com/#{user.screen_name}"
  end
  def vk_audio(audio)
    "http://vk.com/audio/#{audio.aid}"
  end
end
