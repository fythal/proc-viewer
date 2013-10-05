module AnnsHelper

  def link_or_name(ann)
    return "" if ann.nil?

    if ann.procedure.nil?
      ann.name
    else
      link_to ann.name, ann.procedure.path
    end
  end

end
