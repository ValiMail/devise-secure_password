require 'support/string/character_counter'

RSpec.describe Support::String::CharacterCounter do
  let(:bad_string) { nil }
  let(:good_string) { 'ABBabb12!#' }

  let(:uppercase_chars) { ('A'..'Z').to_a }
  let(:lowercase_chars) { ('a'..'z').to_a }
  let(:number_chars) { ('0'..'9').to_a }
  let(:special_chars) { [' ', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '+', '-', '=', '[', ']', '{', '}', '|', '"', '/', '\\', '.', ',', '`', '<', '>', ':', ';', '?', '~', "'"] }
  let(:unknown_chars) { %w(β) }

  describe 'attributes' do
    it { is_expected.to respond_to(:count_hash) }
    it { is_expected.to respond_to(:count) }
  end

  describe '#count' do
    context 'when input string is invalid' do
      it 'raises an ArgumentError' do
        expect { subject.count(bad_string) }.to raise_error(ArgumentError)
      end
    end

    context 'when input string is valid' do
      it 'tallies the correct chracter counts' do
        subject.count(good_string)

        expect(subject.count_hash[:uppercase]['A']).to eq(1)
        expect(subject.count_hash[:uppercase]['B']).to eq(2)
        expect(subject.count_hash[:lowercase]['a']).to eq(1)
        expect(subject.count_hash[:lowercase]['b']).to eq(2)
        expect(subject.count_hash[:number]['1']).to eq(1)
        expect(subject.count_hash[:number]['2']).to eq(1)
        expect(subject.count_hash[:special]['!']).to eq(1)
      end

      it 'correctly categorizes uppercase characters' do
        subject.count(uppercase_chars.join)

        uppercase_chars.each do |c|
          expect(subject.count_hash[:uppercase][c]).to eq(1)
        end
      end

      it 'correctly categorizes lowercase characters' do
        subject.count(lowercase_chars.join)

        lowercase_chars.each do |c|
          expect(subject.count_hash[:lowercase][c]).to eq(1)
        end
      end

      it 'correctly categorizes number characters' do
        subject.count(number_chars.join)

        number_chars.each do |c|
          expect(subject.count_hash[:number][c]).to eq(1)
        end
      end

      it 'correctly categorizes special characters' do
        subject.count(special_chars.join)

        special_chars.each do |c|
          expect(subject.count_hash[:special][c]).to eq(1)
        end
      end

      it 'correctly categorizes unknown characters' do
        subject.count(unknown_chars.join)

        unknown_chars.each do |c|
          expect(subject.count_hash[:unknown][c]).to eq(1)
        end
      end
    end
  end
end
