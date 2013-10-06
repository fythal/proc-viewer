RSpec::Matchers.define :have_no_error_on do |attribute|
  match do |actual|
    actual.errors[attribute].empty?
  end
end

RSpec::Matchers.define :have_any_error_on do |attribute|
  match do |actual|
    !actual.errors[attribute].empty?
  end
end
