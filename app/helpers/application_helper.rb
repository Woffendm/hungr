module ApplicationHelper
  
  # Returns a 'current' tag if given the current page
  def cp(path)
    "active" if request.fullpath.index(path)
  end
  
end
