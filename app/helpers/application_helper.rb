module ApplicationHelper
  def cop(value)
    number_to_currency(
      value.to_i, unit: "$", precision: 0, delimiter: ".", separator: ",",
      format: "%u%n", negative_format: "-%u%n"
    )
  end

  def fecha(date)
    return "—" if date.blank?
    date.strftime("%d/%m/%Y")
  end

  def whatsapp_link(number, message = nil)
    return nil if number.blank?
    url = "https://wa.me/#{number}"
    url += "?text=#{ERB::Util.url_encode(message)}" if message.present?
    url
  end

  def nav_tab_active?(controller_names)
    Array(controller_names).include?(controller.controller_name)
  end

  def fab_target_path
    case controller_name
    when "phones" then new_phone_path
    when "sales" then new_sale_path
    when "credits" then choose_payment_credits_path
    end
  end
end
