class LearningRegistry::Config
  class << self
    attr_accessor :host, :protocol, :hydra, :timeout

    def configure
      yield self
    end

    HYDRA = Typhoeus::Hydra.new(max_concurrency: 20) # keep from killing some servers

    def protocol
      @protocol || "https"
    end

    def host
      @host || "node01.public.learningregistry.net"
    end

    def timeout
      10000
    end

    def hydra
      @hydra || HYDRA
    end

    def base_url
      "#{self.protocol}://#{self.host}"
    end

    def headers
      { headers: { "Accept" => "application/json",
             "Content-Type" => "application/json" } }
    end
  end
end