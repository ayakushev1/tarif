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
    @url  = 'http://www.mytarifs.ru/'
#    raise(StandardError, [@user.email])
    mail(to: @user.email, subject: 'Welcome to My Site')
  end

  def send_mail_to_admin_that_something_wrong_with_confirmation(payment_confirmation)
    @payment_confirmation = payment_confirmation
    mail(to: 'mytarifs@yandex.ru', subject: "Something wrong with payment confirmation from yandex")
  end

  def send_mail_to_admin_about_new_customer_demand(customer_demand)
    @customer_demand = customer_demand
    mail(to: 'mytarifs@yandex.ru', subject: "New customer demand #{customer_demand.id} from #{customer_demand.customer.email}")
  end

  def payment_confirmation(user, payment_confirmation)
    @payment_confirmation = payment_confirmation
    @url  = 'http://www.mytarifs.ru/'
    @user = user
    mail(to: user.email, subject: "Подтверждение перевода денежных средств")
  end

  def tarif_optimization_complete(user_id, result_run_id)
    @url  = result_service_sets_result_url(result_run_id) #'http://www.mytarifs.ru/'
    @user = User.where(:id => user_id).first
    mail(to: @user.email, subject: "Подтверждение завершение подбора тарифа")
  end
end
