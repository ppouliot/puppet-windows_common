Facter.add(:userdomain) do
  confine :kernel => :windows
  setcode do
    ENV['userdomain']
  end
end
