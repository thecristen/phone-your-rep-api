json.motd "Welcome to the PYR OSDI API Entry Point (AEP)"

json._links do
  json.set! "osdi:people" do
    json.href "#{@pfx}/people"
    json.title "The collection of Reps"
  end


end
