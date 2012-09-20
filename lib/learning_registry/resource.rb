class LearningRegistry::Resource
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  self.include_root_in_json = false

  ATTRIBUTES = [ :doc_id,
                 :resource_data_description,
                 :doc_type,
                 :resource_locator,
                 :resorce_data,
                 :keys,
                 :tos,
                 :resource_data_type
                  ]

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

  def self.slice
    ap LearningRegistry::Config.base_url
  end

end