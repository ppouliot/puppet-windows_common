Facter.add(:localappdata) do
  confine :kernel => :windows
  setcode do
    ENV['localappdata']
  end
end
