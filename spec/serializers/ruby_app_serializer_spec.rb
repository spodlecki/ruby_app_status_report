require 'rails_helper'

RSpec.describe RubyAppSerializer do
  let(:model) do
    build_stubbed(:ruby_app, :with_gemfile, ruby_version: '1.8.7')
  end

  let(:serializer) do
    described_class.new(model, {})
                   .as_json
  end

  it 'sets #id' do
    expect(serializer[:id]).to eq(model.id)
  end

  context '#status' do
    it 'eq true when linked' do
      expect(model).to receive(:linked?).and_return(true)
      expect(serializer[:status]).to eq(true)
    end

    it 'eq false when unlinked' do
      expect(model).to receive(:linked?).and_return(false)
      expect(serializer[:status]).to eq(false)
    end
  end

  it 'returns #updated_at field' do
    expect(serializer[:updated_at]).to eq(model.updated_at.utc.to_s)
  end

  it 'returns #name' do
    expect(serializer[:name]).to eq(model.name)
  end

  context '#items' do
    let(:items) { serializer[:items] }

    it 'returns as an array' do
      expect(items).to be_a(Array)
    end

    context 'first record' do
      let(:ruby_version) { items.first.as_json }

      it 'returns #name' do
        expect(ruby_version[:name]).to eq('Ruby')
      end

      it 'returns #version' do
        model.ruby_version = '2.4.1'
        expect(ruby_version[:version]).to eq('2.4.1')
      end
    end

    context 'ruby gems' do
      let(:item) { items.second.as_json }

      before(:each) do
        model.gems.first(2).each do |g|
          create(:ruby_gem_datum, name: g, versions: ['0.0.7', '0.0.1'])
        end
      end

      it 'returns a #name' do
        expect(item[:name]).to eq('abstract_type')
      end

      it 'returns #version' do
        expect(item[:version]).to eq('0.0.7')
      end
    end
  end
end
