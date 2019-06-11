require 'httparty'
require 'byebug'

describe 'NumverifyAPI' do
  invalid_access_key = 'dde5bea93f022675d4akjasdaa5sa178db8ef7'
  access_key = 'cdde5bea93f022675d4aaa5178db8ef7'
  country_code = 'IN'
  number = '9840833711'
  invalid_number = '8743924809328423'
  invalid_access_key_message = 'You have not supplied a valid API Access Key. [Technical Support: support@apilayer.com]'
  string_as_number = 'dkjashdkjashdkjsahk'
  non_numeric_character_for_numbers = 'Please specify a numeric phone number. [Example: 14158586273]'
  missing_access_key_message = 'You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]'
  missing_phone_number = 'Please specify a phone number. [Example: 14158586273]'
  it 'check whether the contact number searched for is valid ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number='+number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['valid']).to eq true
  end

  it 'Check for the keys present when the number searched is valid  ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number='+number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['valid']).to eq true
    expect(response.parsed_response).to include("valid")
    expect(response.parsed_response).to include("number")
    expect(response.parsed_response).to include("local_format")
    expect(response.parsed_response).to include("international_format")
    expect(response.parsed_response).to include("country_prefix")
    expect(response.parsed_response).to include("country_name")
    expect(response.parsed_response).to include("country_code")
    expect(response.parsed_response).to include("location")
    expect(response.parsed_response).to include("carrier")
    expect(response.parsed_response).to include("line_type")
  end

  it 'check for the correct country code,name and prefix when the country name is passed ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number='+number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['country_code']).to eq("IN")
    expect(response.parsed_response['country_name']).to eq("India (Republic of)")
    expect(response.parsed_response['country_prefix']).to eq("+91")
  end

  it 'check for the valid key value when the number does not exist in the database ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number='+invalid_number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['valid']).to eq false
  end

  it 'Verify whether the success key value is false and also check for the error code along with the type and info when access key is invalid ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+invalid_access_key+'&number='+number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['success']).to eq false
    expect(response.parsed_response['error']['code']).to eq 101
    expect(response.parsed_response['error']['type']).to eq('invalid_access_key')
    expect(response.parsed_response['error']['info']).to eq(invalid_access_key_message)
  end

  it 'check for valid key value when the number searched for is invalid ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number='+invalid_number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['valid']).to eq false
  end

  it 'Verify whether the success key value is false and also check for the error code along with the type and info number is passed as non numeric characters ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number='+string_as_number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['success']).to eq false
    expect(response.parsed_response['error']['code']).to eq 211
    expect(response.parsed_response['error']['type']).to eq('non_numeric_phone_number_provided')
    expect(response.parsed_response['error']['info']).to eq(non_numeric_character_for_numbers)
  end


  it 'check for error code,info and type when number is not provided ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key='+access_key+'&number=&country_code='+country_code+'&format=1')
    expect(response.parsed_response['success']).to eq false
    expect(response.parsed_response['error']['code']).to eq 210
    expect(response.parsed_response['error']['type']).to eq('no_phone_number_provided')
    expect(response.parsed_response['error']['info']).to eq(missing_phone_number)
  end


  it 'check for error code,info and type when access key is not provided ' do
    response = HTTParty.get('http://apilayer.net/api/validate?access_key=&number='+number+'&country_code='+country_code+'&format=1')
    expect(response.parsed_response['success']).to eq false
    expect(response.parsed_response['error']['code']).to eq 101
    expect(response.parsed_response['error']['type']).to eq('missing_access_key')
    expect(response.parsed_response['error']['info']).to eq(missing_access_key_message)
  end

end
