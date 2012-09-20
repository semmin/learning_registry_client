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
    parsed = Nokogiri::XML(xml)
    if parsed.xml?
      identifier = parsed.at("//dc:identifier").children.first.to_s if parsed.at("//dc:identifier")
      title = parsed.at("//dc:title").children.first.to_s if parsed.at("//dc:title")
      description = parsed.at("//dc:description").children.first.to_s if parsed.at("//dc:description")
      language = parsed.at("//dc:language").children.first.to_s if parsed.at("//dc:language")
      education_level = parsed.at("//dc:educationLevel").children.first.to_s if parsed.at("//dc:educationLevel")
      audience = parsed.at("//dc:audience").children.first.to_s if parsed.at("//dc:audience")
      subject = parsed.at("//dc:subject").children.first.to_s if parsed.at("//dc:subject")
      publisher = parsed.at("//dc:publisher").children.first.to_s if parsed.at("//dc:publisher")
      type = parsed.at("//dc:type").children.first.to_s if parsed.at("//dc:type")
    end
    new(identifier: identifier, title: title, description: description, language: language,
        education_level: education_level, audience: audience, subject: subject, type: type,
        publisher: publisher)
  end

end