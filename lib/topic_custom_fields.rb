# module TopicCustomFields
# end

class TopicCustomFields
  
  def plugin_enabled?
    SiteSetting.topic_custom_fields_enabled
  end
  
  def add_custom_fields
    # Verificar si el plugin está habilitado
    return unless self..plugin_enabled?

    # Registrar campos personalizados en la base de datos
    Topic.register_custom_field_type("price", :float)
    Topic.register_custom_field_type("link", :string)
  end

  def valid_price?(price)
    # Validación básica para un precio válido
    price.to_s.match?(/\A\d+(\.\d{1,2})?\z/)
  end

  def valid_link?(link)
    # Validación básica para una URL o un handler
    URI::regexp(%w[http https]) =~ link || link.start_with?('@')
  end
end
