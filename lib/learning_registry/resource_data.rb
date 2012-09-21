class LearningRegistry::ResourceData
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  self.include_root_in_json = false

  ATTRIBUTES = [ :identifier,
                 :title,
                 :description,
                 :language,
                 :education_level,
                 :audience,
                 :subject,
                 :publisher,
                 :type ]

  attr_accessor *ATTRIBUTES

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes
    ATTRIBUTES.inject(
      ActiveSupport::HashWithIndifferentAccess.new
      ) do |result, key|

      result[key] = read_attribute_for_validation(key)
      result
      end
  end

  def attributes=(attrs)
    attrs.each_pair do |k, v|
      send("#{k}=", v)
    end
  end

  def read_attribute_for_validation(key)
    send(key)
  end

  def persisted?
    false
  end

  def self.initialize_from_xml_string(xml)
    begin
      parsed = Nokogiri::XML(xml)
      if parsed.xml?
        parsed.remove_namespaces!
        identifier = parsed.at("//identifier").children.first.to_s if parsed.at("//identifier")
        title = parsed.at("//title").children.first.to_s if parsed.at("//title")
        description = parsed.at("//description").children.first.to_s if parsed.at("//description")
        language = parsed.at("//language").children.first.to_s if parsed.at("//language")
        education_level = parsed.at("//educationLevel").children.first.to_s if parsed.at("//educationLevel")
        audience = parsed.at("//audience").children.first.to_s if parsed.at("//audience")
        subject = parsed.at("//subject").children.first.to_s if parsed.at("//subject")
        publisher = parsed.at("//publisher").children.first.to_s if parsed.at("//publisher")
        type = parsed.at("//type").children.first.to_s if parsed.at("//type")
      end
      new(identifier: identifier, title: title, description: description, language: language,
          education_level: education_level, audience: audience, subject: subject, type: type,
          publisher: publisher)
    rescue TypeError
      new()
    end
  end

end
