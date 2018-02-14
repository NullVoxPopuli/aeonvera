namespace :db do
  task :backup do
    `./deployment/production/backup-db`
  end
end
