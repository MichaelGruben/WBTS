module ApplicationHelper
  
  def validateFieldsOf(model)
    returnValue = ""
    if model.errors.any?
      returnValue += "<ul class=\"validation_hint\">"
        model.errors.full_messages.each do |message|
          returnValue += "<li>#{message}</li>"
        end
      returnValue += "</ul>"
    end
    returnValue.html_safe
  end
  
  def ensureSecurity()
    csrf_meta_tags
  end
  
  def showCopyright()
    "&copy;#{Time.now.year} MasterlyMate".html_safe
  end
  
end
