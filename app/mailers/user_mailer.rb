class UserMailer < ActionMailer::Base
  default from: "mytarifs@yandex.ru"

  def receive(email)
    page = Page.find_by(address: email.to.first)
    page.emails.create(
      subject: email.subject,
      body: email.body
    )
 
    if email.has_attachments?
      email.attachments.each do |attachment|
        page.attachments.create({
          file: attachment,
          description: email.subject
        })
      end
    end
  end

  def welcome_email(user)
    @user = user
    @url  = 'http://yakushev-tarif.herokuapp.com/login'
    mail(to: @user.email, subject: 'Welcome to My Site')
  end

end
