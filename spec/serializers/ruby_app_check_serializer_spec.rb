require 'rails_helper'

RSpec.describe RubyAppCheckSerializer do
  let(:model) { build_stubbed(:ruby_app) }

  it 'errors on #as_json' do
    expect { described_class.new(model).as_json }
      .to raise_error(NoMethodError)
  end
end
