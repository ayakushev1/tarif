User.delete_all
User.create(id: 0, name: "guest", password: "111", password_confirmation: "111")
User.create(id: 1, name: "admin", password: "111", password_confirmation: "111")
3.times do |i|
  (11..15).each do |j|
    User.create(id: (i*100+j),name: "user "+(i*100+j).to_s, password: "111", password_confirmation: "111")
  end
end
