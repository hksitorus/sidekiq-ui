require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'rack/session'
use Rack::Session::Cookie, secret: File.read(".session.key"), same_site: true, max_age: 86400

Sidekiq.configure_client do |config|
  config.redis = {
    url: ENV.fetch('REDIS_URL','redis://localhost:6379'),
    size: 1
  }
end

mount_at = ENV['MOUNT_AT'] ? ENV['MOUNT_AT'] : '/'
map mount_at do
  if ENV['USERNAME'] && ENV['PASSWORD']
    use Rack::Auth::Basic, "Protected Area" do |username, password|
      # Protect against timing attacks: (https://codahale.com/a-lesson-in-timing-attacks/)
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(ENV["USERNAME"])) &
        Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["PASSWORD"]))
    end
  end

  run Sidekiq::Web
end