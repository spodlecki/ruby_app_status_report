require 'rails_helper'

RSpec.describe RubyGemDatum, type: :model do
  let(:model) { described_class.new }

  it { is_expected.to validate_presence_of(:name) }

  describe '#versions' do
    it 'returns an array' do
      expect(model.versions).to eq([])
    end

    it 'can store many versions' do
      model.versions = ['1.1.1', '1.1.4']
      expect(model.versions).to eq(['1.1.1', '1.1.4'])
    end
  end

  describe '#latest' do
    before(:each) do
      model.versions = ['1.1.1', '1.2.4', '1.2.4.4', '1.2.8.4', '0.0.3', '1.1.1.2']
    end

    context 'without any params' do
      it 'returns the most recent version stored' do
        expect(model.latest).to eq('1.2.8.4')
      end
    end

    context 'with :major' do
      it 'returns highest for major' do
        expect(model.latest(major: '0'))
          .to eq('0.0.3')
      end

      context 'and with :minor' do
        it 'returns highest group' do
          expect(model.latest(major: '1', minor: '1'))
            .to eq('1.1.1.2')
        end

        context 'and with :patch' do
          it 'returns highest group' do
            expect(model.latest(major: '1', minor: '2', patch: '4'))
              .to eq('1.2.4.4')
          end
        end
      end
    end
  end

  describe '#push_versions' do
    let(:versions) do
      JSON.parse(
        File.read(
          Rails.root.join('spec',
                          'support',
                          'webmock',
                          'rubygems-rails-versions.json')
        )
      )[0..40]
    end

    it 'skips any prerelease' do
      model.push_versions(versions)
      expect(model.versions).to eq(["5.1.3",
                                    "5.1.2",
                                    "5.1.1",
                                    "5.1.0",
                                    "5.0.5",
                                    "5.0.4",
                                    "5.0.3",
                                    "5.0.2",
                                    "5.0.1",
                                    "5.0.0.1",
                                    "5.0.0",
                                    "4.2.9",
                                    "4.2.8",
                                    "4.2.7.1",
                                    "4.2.7"])
    end
  end
end

# == Schema Information
#
# Table name: ruby_gem_data
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  versions   :text
#  skip       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
