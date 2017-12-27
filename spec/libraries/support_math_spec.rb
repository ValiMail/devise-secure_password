RSpec.describe Support::Math::Integer do
  describe 'constants' do
    it { is_expected.to have_constant(:N_BYTES) }
    it { is_expected.to have_constant(:N_BITS) }
    it { is_expected.to have_constant(:MAX) }
    it { is_expected.to have_constant(:MIN) }
  end
end
