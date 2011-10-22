module TecDoc
  class VehicleModel
    attr_accessor :id, :name, :date_of_construction_from, :date_of_construction_to

    # Get all vehicle models
    # 
    # @option options [Integer] :car_type vehicle type (1: Passenger car, 2: Commercial vehicle, 3: Light commercial)
    # @option options [String] :countries_car_selection country code according to ISO 3166
    # @option options [TrueClass, FalseClass] :country_group_flag country group selection
    # @option options [TrueClass, FalseClass] :eval_favor simplified Flag: simplified vehicle selection
    # @option options [Integer, NilClass] :favoured_list simplified vehicle selection (1: first list selection, 0: rest) (optional)
    # @option options [String] :lang language code according to ISO 639
    # @option options [Integer] :manu_id manufacturer id
    # @return [Array<TecDoc::VehicleManufacturer>] list of languages
    def self.all(options)
      response = TecDoc.client.request(:get_vehicle_models3, options)
      response.to_hash[:get_vehicle_models3_response][:get_vehicle_models3_return][:data][:array][:array].map do |attributes|
        model = new
        model.id = attributes[:model_id].to_i
        model.name = attributes[:modelname].to_s
        if attributes[:year_of_constr_from]
          year, month = attributes[:year_of_constr_from].to_i.divmod(100)
          model.date_of_construction_from = Date.new(year, month, 1)
        end
        if attributes[:year_of_constr_to]
          year, month = attributes[:year_of_constr_to].to_i.divmod(100)
          model.date_of_construction_to = Date.new(year, month, 1)
        end
        model
      end
    end
  end
end