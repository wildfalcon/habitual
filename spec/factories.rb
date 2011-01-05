Factory.define(:habit) do |f|
  f.name "A habit"
end

Factory.define(:user) do |f|
  f.name "A user"
  f.sequence(:uid) {|n| n }
end
