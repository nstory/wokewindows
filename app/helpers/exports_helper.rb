module ExportsHelper
  def export_last_modified(export)
    raw("#{time_tag(export.last_modified)} UTC")
  end

  def export_link(export)
    link_to(export.public_url.sub(/^.*\//, ""), export.public_url)
  end

  def export_size(export)
    number_to_human_size(export.size)
  end
end
