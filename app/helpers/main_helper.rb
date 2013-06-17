module MainHelper
  def item_source(id, items)
    return items.profiles.detect { |i| i.uid==id } if id>0
    return items.groups.detect { |i| i.gid==-id }
  end
  def item_sources(item, items)
    [item.source_id,item.copy_owner_id].map{|id| item_source(id,items) if id.present?}.compact
  end

  def human_source_name(source)
    text= source.name || "#{source.first_name} #{source.last_name}"
    link_to(text,vk_url(source))
  end
end
