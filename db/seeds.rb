DemoData.load!

# Creates/updates the login user from ENV vars, so no password ever lives in
# the (public) git repo. Set HIMOVIL_LOGIN_EMAIL / HIMOVIL_LOGIN_PASSWORD on
# the host (e.g. Railway variables) before the first deploy; db:prepare runs
# this file automatically the first time it creates the database.
if ENV["HIMOVIL_LOGIN_PASSWORD"].present?
  user = User.find_or_initialize_by(email_address: ENV.fetch("HIMOVIL_LOGIN_EMAIL", "himovil"))
  user.password = ENV["HIMOVIL_LOGIN_PASSWORD"]
  user.password_confirmation = ENV["HIMOVIL_LOGIN_PASSWORD"]
  user.save!
  puts "Usuario de login listo: #{user.email_address}"
end
