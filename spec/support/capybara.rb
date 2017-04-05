def reload_page
  page.evaluate_script <<-JAVASCRIPT
    window.location.reload()
  JAVASCRIPT
end
