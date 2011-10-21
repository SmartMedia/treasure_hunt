require 'spec_helper'
require 'action_controller'
require 'generator_spec/test_case'

require 'generators/install/install_generator'

describe TreasureHunt::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../../../../../tmp', __FILE__)

  before do
    prepare_destination
    run_generator
  end

  specify do
    destination_root.should have_structure {
      directory 'app' do
        directory 'models' do
          file 'achievement.rb' do
            contains 'class Achievement'
          end

          file 'reward.rb' do
            contains 'class Reward'
          end
        end
      end

      directory 'db' do
        directory 'migrate' do
          migration 'create_treasure_hunt_tables' do
            contains 'class CreateTreasureHuntTables'
            contains 'create_table :achievements'
            contains 'create_table :rewards'
          end
        end
      end
    }
  end
end
