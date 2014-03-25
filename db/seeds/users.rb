User.delete_all
User.create(id: 0, name: "guest", password: "111", password_confirmation: "111")
User.create(id: 1, name: "admin", password: "111", password_confirmation: "111")
3.times do |i|
  (11..15).each do |j|
    User.create(id: (i*100+j),name: "user "+(i*100+j).to_s, password: "111", password_confirmation: "111")
  end
end

Test.delete_all
Test.create(id: 1, name: 'Test 1', user_id: 0)
Test.create(id: 2, name: 'Test 2', user_id: 1)
Test.create(id: 3, name: 'Test 3', user_id: 11)
