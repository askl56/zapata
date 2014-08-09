require 'rails_helper'

describe TestSend do
  let(:test_send) do
    TestSend.new
  end

  it '#another_method_as_arg' do
    expect(test_send.another_method_as_arg('Help method')).to eq('Help method')
  end

  it '#second_level_method_chain' do
    expect(test_send.second_level_method_chain('Help method')).to eq('Help method')
  end

  it '#third_level_method_chain' do
    expect(test_send.third_level_method_chain('Help method')).to eq('Help method')
  end

  it '#method_with_calculated_value' do
    expect(test_send.method_with_calculated_value('Missing "calculated_value"')).to eq('Missing "calculated_value"')
  end

  it '#to_another_object' do
    expect(test_send.to_another_object(AnotherObject.my_name)).to eq('Domas')
  end

  it '#to_another_object_with_params' do
    expect(test_send.to_another_object_with_params('Missing "deep_dive"')).to eq('Missing "deep_dive"')
  end
end

describe AnotherObject do
  let(:another_object) do
    AnotherObject.new
  end

  it '#my_name' do
    expect(AnotherObject.my_name).to eq('Domas')
  end

  it '#send_with_params' do
    expect(AnotherObject.send_with_params('Missing "id"')).to eq('Id was Missing "id"')
  end
end
