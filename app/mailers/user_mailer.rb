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
    @url  = 'http://www.mytarifs.ru'/
#    raise(StandardError, [@user.email])
    mail(to: @user.email, subject: 'Welcome to My Site')
  end

  def send_mail_to_admin_that_something_wrong_with_confirmation(payment_confirmation)
    @payment_confirmation = payment_confirmation
    mail(to: 'mytarifs@yandex.ru', subject: "something wrong with payment confirmation from yandex")
  end

  def payment_confirmation(user, payment_confirmation)
    @payment_confirmation = payment_confirmation
    @url  = 'http://www.mytarifs.ru/'
    @user = user
    mail(to: user.email, subject: "Подтверждение перевода денежных средств")
  end
end
