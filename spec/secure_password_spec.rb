RSpec.describe Devise::SecurePassword do
  it 'has a version number' do
    expect(Devise::SecurePassword::VERSION).not_to be nil
  end

  context 'configuration parameters' do
    %w(password_required_uppercase_count
       password_required_lowercase_count
       password_required_number_count
       password_required_special_character_count
       password_previously_used_count
       password_minimum_age
       password_maximum_age).each do |attr|
      it "#{attr} should be a Devise configuration variable" do
        expect(Devise).to respond_to(attr)
        expect(Devise).to respond_to("#{attr}=")
      end
    end
  end
end
