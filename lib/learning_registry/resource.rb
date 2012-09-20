class LearningRegistry::Resource
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  self.include_root_in_json = false

  ATTRIBUTES = [ :doc_id,
                 :doc_type,
                 :resource_locator,
                 :update_timestamp,
                 :resource_data,
                 :keys,
                 :tos,
                 :rev,
                 :resource_data_type,
                 :payload_schema_locator,
                 :payload_placement,
                 :payload_schema,
                 :node_timestamp,
                 :digital_signature,
                 :create_timestamp,
                 :doc_version,
                 :active,
                 :publishing_node,
                 :identity ]

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

  def self.initialize_from_api(keywords)
    request = Typhoeus::Request.new(LearningRegistry::Config.base_url +
                                    "/slice?any_tags=#{keywords}",
                                    { method: :get,
                                     timeout: LearningRegistry::Config.timeout }.merge(LearningRegistry::Config.headers))

    request.on_complete do |response|
      if response.code == 200
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        documents = parsed[:documents]
        ap documents.first[:resource_data_description].keys
      else
        return nil
      end
    end

    LearningRegistry::Config.hydra.queue(request)
  end

  def self.slice(options={})
    attrs = options.select {|k,v| %(any_tags identity from until).include?(k.to_s) && v.present?}
    keywords = "metadata," + attrs[:any_tags].split(" ").join(",")
    attrs[:any_tags] = keywords
    ap params = attrs.to_param
    request = Typhoeus::Request.new(LearningRegistry::Config.base_url +
                                    "/slice?#{params}",
                                    { method: :get,
                                     timeout: LearningRegistry::Config.timeout }.merge(LearningRegistry::Config.headers))

    request.on_complete do |response|
      if response.code == 200
        parsed = Yajl::Parser.parse(response.body, symbolize_keys: true)
        documents = parsed[:documents]
        resources = []
        documents.each do |document|
          resources << new( doc_id: document[:doc_ID],
                          doc_type: document[:resource_data_description][:doc_type],
                  resource_locator: document[:resource_data_description][:resource_locator],
                  update_timestamp: document[:resource_data_description][:update_timestamp],
                     resource_data: LearningRegistry::ResourceData.initialize_from_xml_string(document[:resource_data_description][:resource_data]),
                              keys: document[:resource_data_description][:keys],
                               tos: document[:resource_data_description][:TOS],
                               rev: document[:resource_data_description][:rev],
                resource_data_type: document[:resource_data_description][:resource_data_type],
            payload_schema_locator: document[:resource_data_description][:payload_schema_locator],
                 payload_placement: document[:resource_data_description][:payload_placement],
                    payload_schema: document[:resource_data_description][:payload_schema],
                    node_timestamp: document[:resource_data_description][:node_timestamp],
                 digital_signature: document[:resource_data_description][:digital_signature],
                  create_timestamp: document[:resource_data_description][:create_timestamp],
                       doc_version: document[:resource_data_description][:doc_version],
                            active: document[:resource_data_description][:active],
                   publishing_node: document[:resource_data_description][:publishing_node],
                          identity: document[:resource_data_description][:identity])
        end
        yield resources, parsed[:resumption_token], parsed[:resultCount]
      else
        return nil
      end
    end

    LearningRegistry::Config.hydra.queue(request)
  end

end