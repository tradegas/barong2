module ApplicationHelper
  def domain_favicon_tag
    return favicon_link_tag asset_path('favicon.png'), rel: 'icon', type:  'image/png'
	end
	
  def show_level_mapping
      Level.all.map do |lvl|
        "#{lvl.key}:#{lvl.value} scope \"private\"=> account level #{lvl.id}"
      end.join("\n")
	end
end
