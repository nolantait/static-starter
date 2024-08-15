# frozen_string_literal: true

desc "Precompile assets"
task :environment do
  require "./config/boot"
end

namespace :assets do
  desc "Precompile assets"
  task precompile: :environment do
    Staticky::Builder.call
  end
end
