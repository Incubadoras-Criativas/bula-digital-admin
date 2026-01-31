# Caminhos
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Opções principais
# Ajuste o número de workers conforme sua RAM e CPUs
worker_processes 10
preload_app true
timeout 30 # Muito mais seguro que 3000

# Socket e Backlog (64 é baixo para muito tráfego, 2048 é o padrão comum)
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 1024

# Logs e PID
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"
pid "#{shared_dir}/pids/unicorn.pid"

# Lógica de Forking (Crucial para Rails)
before_fork do |server, worker|
  # Fecha a conexão com o banco no processo Master
  defined?(ActiveRecord::Base) && ActiveRecord::Base.connection.disconnect!

  # Tenta matar o worker antigo de forma suave durante o deploy (Zero downtime)
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # Já foi morto por outro processo
    end
  end
end

after_fork do |server, worker|
  # Abre a conexão com o banco em cada Worker novo
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
