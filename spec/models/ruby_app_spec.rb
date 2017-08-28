require 'rails_helper'

RSpec.describe RubyApp, type: :model do
  let(:model) { described_class.new }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:repo_url) }
  it { is_expected.to validate_presence_of(:api_type) }
  it { is_expected.to have_one(:gemfile).dependent(:destroy) }

  context 'Factories' do
    it 'creates from factory' do
      expect { create(:ruby_app) }
        .to change(RubyApp, :count).by(1)
    end

    it 'creates Gemfile with trait' do
      expect { create(:ruby_app, :with_gemfile) }
        .to change(Gemfile, :count).by(1)
    end

    context 'stubbed' do
      it 'does not create Gemfile' do
        expect { build_stubbed(:ruby_app, :with_gemfile) }
          .to change(Gemfile, :count).by(0)
      end

      it 'does not create RubyApp' do
        expect { build_stubbed(:ruby_app, :with_gemfile) }
          .to change(RubyApp, :count).by(0)
      end
    end
  end

  describe '#api_type' do
    it 'is set to gitlab? by default' do
      expect(model.gitlab?).to eq(true)
    end
  end

  describe '#api_data' do
    before(:each) do
      expect(AppConfig).to receive(:defaults)
        .at_least(:once)
        .and_return('gitlab_endpoint' => 'http://example.com/v4/',
                    'gitlab_token' => 'AAAAAAA')
    end

    it 'has gitlab requirements' do
      expect(model.gitlab_endpoint).to eq('http://example.com/v4/')
      expect(model.gitlab_private_token).to eq('AAAAAAA')
    end
  end

  describe '#gitlab_project_id' do
    it 'can set the project id' do
      model.gitlab_project_id = 10
      expect(model.gitlab_project_id).to eq(10)
    end

    it 'marks dirty model when setting' do
      model.gitlab_project_id = 10
      expect(model.changed?).to eq(true)
    end
  end
end

# == Schema Information
#
# Table name: ruby_apps
#
#  id           :integer          not null, primary key
#  name         :string           not null
#  repo_url     :string           not null
#  api_type     :integer          default("gitlab"), not null
#  api_data     :text
#  last_check   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  ruby_version :string
#
