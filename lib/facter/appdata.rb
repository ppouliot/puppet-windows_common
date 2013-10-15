Facter.add(:appdata) do
  confine :kernel => :windows
  setcode do
    ENV['appdata']
  end
end
