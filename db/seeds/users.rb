User.delete_all
User.create(id: 0, name: "guest", password: "111", password_confirmation: "111")
User.create(id: 1, name: "admin", password: "111", password_confirmation: "111")
