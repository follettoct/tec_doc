module TecDoc
  class Client
    attr_accessor :provider, :connection

    def initialize(options = {})
      self.provider = options[:provider]
      self.connection = Savon::Client.new("http://webservicepilot.tecdoc.net/pegasus-2-0/wsdl/TecdocToCatWL")
    end

    def request(operation, options = {})
      response = connection.request(operation) do
        soap.body = { :in => { :provider => provider }.merge(options) }
      end
      response.doc.xpath("//data/array/array").map do |node|
        node_to_hash(node)
      end
      # response
    end

    private

    def node_to_hash(node)
      attributes = {}
      node.children.each do |n|
        n_array = n.xpath("array/array")
        if n_array.size > 0
          attributes[n.name.snakecase.to_sym] = n_array.map { |nn| node_to_hash(nn) }
        elsif n.children.reject { |nn| nn.is_a?(Nokogiri::XML::Text) }.size > 0
          attributes[n.name.snakecase.to_sym] = node_to_hash(n)
        elsif n.text == ""
          attributes[n.name.snakecase.to_sym] = nil
        else
          attributes[n.name.snakecase.to_sym] = n.text
        end
      end
      attributes
    end
  end
end
