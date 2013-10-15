Facter.add(:userdomain_roamingprofile) do
  confine :kernel => :windows
  setcode do
    ENV['userdomain_roamingprofile']
  end
end
