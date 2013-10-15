Facter.add(:tmp) do
  confine :kernel => :windows
  setcode do
    ENV['tmp']
  end
end
