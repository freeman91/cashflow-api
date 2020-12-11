# frozen_string_literal: true

namespace :db do
  namespace :seed do
    task single: :environment do
      filename = Dir[File.join(Rails.root, 'db', 'seeds', "#{ENV['SEED']}.rb")][0]
      puts "\tSeeding #{filename}..."
      load(filename) if File.exist?(filename)
    end
  end
end
