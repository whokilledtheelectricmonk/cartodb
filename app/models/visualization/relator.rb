# encoding: utf-8
require_relative './stats'
require_relative '../table'
require_relative '../overlay/collection'

module CartoDB
  module Visualization
    class Relator
      LAYER_SCOPES  = {
                        base:     :user_layers,
                        cartodb:  :data_layers
                      }

      INTERFACE     = %w{ overlays map user table related_tables layers stats }
      def initialize(attributes={})
        @id     = attributes.fetch(:id)
        @map_id = attributes.fetch(:map_id)
      end #initialize

      def overlays
        Overlay::Collection.new(visualization_id: id).fetch
      end #overlays

      def map
        @map ||= ::Map.where(id: map_id).first
      end #map

      def user
        map.user if map
      end #user

      def table
        return nil unless defined?(::Table)
        ::Table.where(map_id: map_id).first 
      end #table

      def related_tables
        layers(:cartodb).flat_map(&:affected_tables).uniq
      end #related_tables

      def layers(kind)
        return [] unless map
        return map.send(LAYER_SCOPES.fetch(kind))
      end #layers

      def stats
        Visualization::Stats.new(self).to_poro
      end #stats

      attr_reader :id, :map_id
    end # Relator
  end # Visualization
end # CartoDB

