def expect_content(id, content)
  expect(page.find "##{id}").to have_content content
end

def click(link_text)
  click_link link_text
  expect(page).to have_no_content link_text
end

def set_lobby_user(user)
  return if user.nil?
  page.set_rack_session lobby_user_ids: [user.guid]
end
