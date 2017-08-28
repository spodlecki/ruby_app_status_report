require 'rails_helper'

RSpec.describe RubyVersion, type: :model do
  let(:model) { described_class.new }
  let(:versions) do
    ['1.2.8.4',
     '1.2.4.4',
     '1.2.4',
     '1.1.1.2',
     '1.1.1',
     '0.0.3']
  end
  it { is_expected.to validate_presence_of(:version) }

  describe '.latest_ruby' do
    before(:each) do
      versions.each do |ver|
        described_class.create(version: ver)
      end
    end

    context 'without any params' do
      it 'returns the most recent version stored' do
        expect(described_class.latest_ruby).to eq('1.2.8.4')
      end
    end

    context 'with :major' do
      it 'returns highest for major' do
        expect(described_class.latest_ruby(major: '0'))
          .to eq('0.0.3')
      end

      context 'and with :minor' do
        it 'returns highest group' do
          expect(described_class.latest_ruby(major: '1',
                                             minor: '1'))
            .to eq('1.1.1.2')
        end

        context 'and with :patch' do
          it 'returns highest group' do
            expect(described_class.latest_ruby(major: '1',
                                               minor: '2',
                                               patch: '4'))
              .to eq('1.2.4.4')
          end
        end
      end
    end
  end

  describe '.versions' do
    before(:each) do
      versions.reverse.each do |ver|
        described_class.create(version: ver)
      end
    end

    it 'returns all version names' do
      expect(described_class.versions)
        .to eq(versions)
    end
  end

  describe '#version' do
    it 'forces specific format' do
      model.version = '2.4.1'
      expect(model).to be_valid
    end

    it 'does not allow pre releases' do
      model.version = '2.4.1-p333'
      expect(model).not_to be_valid
    end
  end
end

# == Schema Information
#
# Table name: ruby_versions
#
#  id         :integer          not null, primary key
#  version    :string           not null
#  released   :date
#  notes_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
