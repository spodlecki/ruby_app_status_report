require 'rails_helper'

RSpec.describe RubyGemDatumSerializer do
  let(:model) do
    build_stubbed(:ruby_gem_datum, versions: ['0.1.1',
                                              '0.2.5',
                                              '2.4.1',
                                              '2.4.1.1',
                                              '1.1.1'])
  end
  let(:current_version) { '1.1.1' }
  let(:serializer) do
    described_class.new(model, { current_version: current_version })
                   .as_json
  end

  it 'returns #name' do
    expect(serializer[:name]).to eq(model.name)
  end

  it 'returns #version' do
    expect(serializer[:version]).to eq(current_version)
  end

  describe '#level' do
    context do
      let(:current_version) { '0.1.1' }
      it 'returns "1" when needs major update (0.1.1 > 1.0.0)' do
        expect(serializer[:level]).to eq(1)
      end
    end

    context do
      let(:current_version) { '2.2.1' }
      it 'returns "2" if needing a minor update (2.2.1 > 2.4.1)' do
        expect(serializer[:level]).to eq(2)
      end
    end

    context do
      let(:current_version) { '2.4.0' }
      it 'returns "3" when needing patch (2.4.0 > 2.4.1)' do
        expect(serializer[:level]).to eq(3)
      end
    end

    context do
      let(:current_version) { '2.4.1' }
      it 'returns "3" when needing long path (2.4.1 > 2.4.1.1)' do
        expect(serializer[:level]).to eq(3)
      end
    end

    context do
      let(:current_version) { '4.4.0' }
      it 'returns "4" versions are missing' do
        current_version = '4.4.0'
        expect(serializer[:level]).to eq(4)
      end
    end

    context do
      let(:current_version) { '2.4.1.1' }
      it 'returns "5" if matching latest' do
        current_version = '2.4.1.1'
        expect(serializer[:level]).to eq(5)
      end
    end
  end

  describe '#note' do
    context do
      let(:current_version) { '2.4.1.1' }
      it 'returns "up to date" when current version' do
        expect(serializer[:note]).to eq('up to date')
      end
    end

    context do
      let(:current_version) { '0.0.1' }
      it 'returns the list of possible updates' do
        expect(serializer[:note]).to eq('updates; 2.4.1.1, 0.2.5')
      end
    end
  end
end
