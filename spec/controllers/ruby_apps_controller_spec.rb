require 'rails_helper'

RSpec.describe RubyAppsController, type: :controller do
  describe '#index' do
    before(:all) do
      create_list(:ruby_app, 5, :with_gemfile)
    end

    after(:all) do
      RubyApp.destroy_all
    end

    it 'renders with :ok' do
      expect(get(:index)).to be_success
    end

    it 'renders JSON Array' do
      get :index
      expect(JSON.parse(response.body)).to be_a(Array)
    end

    it 'generates from a Serializer' do
      expect(RubyAppSerializer).to receive(:new)
        .exactly(5)
        .times
        .and_call_original

      get :index
    end
  end

  describe '#show' do
    let(:model) { create(:ruby_app, :with_gemfile) }

    it 'displays a single ruby app' do
      get :show, params: { id: model.id }
      expect(response).to be_success
    end

    it 'generates from a Serializer' do
      expect(RubyAppSerializer).to receive(:new)
        .once
        .and_call_original

      get :show, params: { id: model.id }
    end
  end
end
