require 'rails/generators/active_record'

module TreasureHunt
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Generates treasure_hunt models and migrations to User model'

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def self.next_migration_number(path)
        ActiveRecord::Generators::Base.next_migration_number(path)
      end

      def generate_migration
        migration_template 'migration.rb', 'db/migrate/create_treasure_hunt_tables'
      end

      def generate_models
        template 'achievement.rb', 'app/models/achievement.rb'
        template 'reward.rb', 'app/models/reward.rb'
      end

      def add_acts_as_treasure_hunter
        say "Please add 'acts_as_treasure_hunter' to your User model", :green
      end
    end
  end
end
