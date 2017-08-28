require 'rails_helper'

RSpec.describe Gemfile, type: :model do
  let(:model) { described_class.new }
  let(:gemfile_lock) do
    File.read( Rails.root.join('spec', 'support', 'Gemfile.lock.sample') )
  end

  it { is_expected.to belong_to(:ruby_app) }
  it { is_expected.to validate_presence_of(:ruby_app_id) }

  context 'Factories' do
    it 'creates from factory' do
      expect { create(:gemfile) }
        .to change(Gemfile, :count).by(1)
    end

    context 'stubbed' do
      it 'does not create Gemfile' do
        expect { build_stubbed(:gemfile) }
          .to change(Gemfile, :count).by(0)
      end

      it 'does not create RubyApp' do
        expect { build_stubbed(:gemfile) }
          .to change(RubyApp, :count).by(0)
      end
    end
  end

  describe '#gems' do
    it 'returns empty array by default' do
      expect(model.gems).to eq([])
    end

    context 'with info from gemfile' do
      before(:each) do
        model.parse_gemfile_lock(gemfile_lock)
      end

      it 'sets gems' do
        expect(model.gems.count)
          .to eq(400)
      end

      it 'sorts the gems in order' do
        expect(model.gems.first).to eq('abstract_type')
      end
    end
  end

  describe '#version' do
    before(:each) do
      model.parse_gemfile_lock(gemfile_lock)
    end

    it 'returns valid version from selected gem' do
      expect(model.version(:url_safe_base64)).to eq('0.2.2')
    end

    it 'returns nil if gem does not exist' do
      expect(model.version('hello world')).to eq(nil)
    end
  end

  describe '#data' do
    it 'returns hash' do
      expect(model.data).to eq({})
    end
  end
end

# == Schema Information
#
# Table name: gemfiles
#
#  id          :integer          not null, primary key
#  ruby_app_id :integer          not null
#  data        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
