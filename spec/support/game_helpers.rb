def expect_content(id, content, expect=true)
  method = expect ? :have_content : :have_no_content
  expect(page.find "##{id}").to self.send(method, content)
end

def click(link_text)
  click_link link_text
  expect(page).to have_no_content link_text
end

def set_lobby_user(user)
  return if user.nil?
  page.set_rack_session lobby_user_ids: [user.guid]
end

def wait_until
  require 'timeout'
  Timeout.timeout(Capybara.default_max_wait_time) do
    sleep(0.1) until (value = yield)
    value
  end
end
