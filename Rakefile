# add other tasks here as needed
namespace :oleana do
  desc "Start Oleana for development"
  task :start do
    system "rackup config.ru"
  end
end

desc "Start everything."
multitask :start => [ 'oleana:start' ]
