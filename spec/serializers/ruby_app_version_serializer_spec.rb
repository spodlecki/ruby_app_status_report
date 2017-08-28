require 'rails_helper'

RSpec.describe RubyAppVersionSerializer do
  let(:model) do
    build_stubbed(:ruby_app, ruby_version: '1.8.7')
  end

  let(:serializer) do
    described_class.new(model, {})
                   .as_json
  end

  let(:latest_ruby) { RubyVersion.latest_ruby }

  it 'returns #name' do
    expect(serializer[:name]).to eq('Ruby')
  end

  it 'returns #version' do
    model.ruby_version = '2.4.1'
    expect(serializer[:version]).to eq('2.4.1')
  end

  describe '#level' do
    it 'returns "1" when needs major update (0.1.1 > 1.0.0)' do
      create(:ruby_version, version: '0.2.3')
      create(:ruby_version, version: '1.2.3')
      model.ruby_version = '0.0.1'
      expect(serializer[:level]).to eq(1)
    end

    it 'returns "2" if needing a minor update (2.2.1 > 2.4.1)' do
      create(:ruby_version, version: '2.4.1')
      model.ruby_version = '2.2.1'
      expect(serializer[:level]).to eq(2)
    end

    it 'returns "3" when needing patch (2.4.0 > 2.4.1)' do
      create(:ruby_version, version: '2.4.1')
      model.ruby_version = '2.4.0'
      expect(serializer[:level]).to eq(3)
    end

    it 'returns "3" when needing long path (2.4.1 > 2.4.1.1)' do
      create(:ruby_version, version: '2.4.1')
      create(:ruby_version, version: '2.4.1.1')
      model.ruby_version = '2.4.1'
      expect(serializer[:level]).to eq(3)
    end

    it 'returns "4" versions are missing' do
      model.ruby_version = '2.4.0'
      expect(serializer[:level]).to eq(4)
    end

    it 'returns "5" if matching latest' do
      create(:ruby_version, version: '2.4.1.1')
      model.ruby_version = latest_ruby
      expect(serializer[:level]).to eq(5)
    end
  end

  describe '#note' do
    it 'returns "up to date" when current version' do
      create(:ruby_version, version: '2.4.1.1')
      create(:ruby_version, version: '2.4.0')
      create(:ruby_version, version: '0.0.0.1')
      model.ruby_version = latest_ruby
      expect(serializer[:note]).to eq('up to date')
    end

    it 'returns the list of possible updates' do
      create(:ruby_version, version: '2.4.1.1')
      create(:ruby_version, version: '2.4.0')
      create(:ruby_version, version: '0.2.0')
      create(:ruby_version, version: '0.0.1.1')
      create(:ruby_version, version: '0.0.0')
      model.ruby_version = '0.0.1'
      expect(serializer[:note]).to eq('updates; 2.4.1.1, 0.2.0, 0.0.1.1')
    end
  end
end
