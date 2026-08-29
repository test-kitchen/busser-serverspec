require "serverspec"

# The suite runs on the machine under test, after Test Kitchen has logged in,
# so exec is the right backend. ssh would connect back out from the target.
set :backend, :exec
