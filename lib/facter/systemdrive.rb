Facter.add(:systemdrive) do
  confine :kernel => :windows
  setcode do
    ENV['systemdrive']
  end
end
