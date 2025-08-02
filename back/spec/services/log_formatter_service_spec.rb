require 'rails_helper'

RSpec.describe LogFormatterService, type: :service do
  it { is_expected.to be_is_a(ApplicationService) }

  describe '#call' do
    it 'must be valid' do
      expect(subject).to receive(:controller) { instance_double(ActionController::Base) }
      expect(subject).to receive(:request) { instance_double(ActionDispatch::Request) }
      expect(subject).to receive(:response) { instance_double(ActionDispatch::Response, status: 422) }.at_least(:once)

      class << subject
        def run
          @result = { key: 'value' }.to_json
        end
      end

      expect(subject.call('INFO', Time.current, 'test', 'test')).to eq({ key: 'value' }.to_json)
      expect(subject.errors).to be_empty
    end

    it 'must be invalid' do
      expect(subject).not_to receive(:run)

      expect(subject.call('INFO', Time.current, 'test', 'test')).to be_falsey
      expect(subject.errors.details[:controller]).to be_include(error: :blank)
    end

    it 'must be invalid by run' do
      expect(subject).to receive(:controller) { instance_double(ActionController::Base) }
      expect(subject).to receive(:request) { instance_double(ActionDispatch::Request) }
      expect(subject).to receive(:response) { instance_double(ActionDispatch::Response, status: 422) }.at_least(:once)

      class << subject
        def run
          errors.add(:base, 'message')
        end
      end

      expect(subject.call('INFO', Time.current, 'test', 'test')).to be_falsey
      expect(subject.errors.details[:base]).to be_include(error: 'message')
    end
  end

  it '#run' do
    request = instance_double(
      ActionDispatch::Request,
      method: 'POST',
      url: 'https://example.com',
      headers: {
        'HTTP_AUTHORIZATION' => 'Bearer 123',
        'CONTENT_TYPE' => 'application/json',
        'HTTP_COOKIE' => 'abc',
        'KEY' => 'value'
      },
      query_parameters: { id: 1 },
      request_parameters: { name: 'Name' }
    )
    response = instance_double(
      ActionDispatch::Response,
      status: 422,
      body: { key: 'value' }.to_json,
      headers: {
        'HTTP_ACCEPT' => 'application/json',
        'CONTENT_TYPE' => 'application/json',
        'HTTP_COOKIE' => 'abc',
        'KEY' => 'value'
      }
    )
    controller = instance_double(
      STANDARD::ApplicationController,
      request:,
      response:,
      current_user: build(:user, id: 1),
      current_subscription: build(:subscription, id: 2),
      current_client: build(:user, id: 3)
    )
    segment = instance_double(NewRelic::Agent::Transaction::Segment)

    expect(NewRelic::Agent::Tracer).to receive(:current_segment) { segment }.at_least(:once)
    expect(segment).to receive(:instance_variable_get).with(:@controller) { controller }.at_least(:once)

    expect(subject.send(:run)).to eq(
      [
        {
          current_user: { id: 1 },
          current_subscription: { id: 2 },
          current_client: { id: 3 },
          request: {
            method: 'POST',
            headers: {
              'Authorization' => 'Bearer 123',
              'Content-Type' => 'application/json'
            },
            url: 'https://example.com',
            query: { id: 1 },
            body: { name: 'Name' }
          },
          response: {
            status: 422,
            headers: {
              'Accept' => 'application/json',
              'Content-Type' => 'application/json'
            },
            body: { key: 'value' }
          }
        }.to_json,
        "\n"
      ].join
    )
  end

  describe '#controller' do
    it 'must be present' do
      class << subject; attr_accessor :controller; end
      expect(subject).to validate_presence_of(:controller)
    end

    it 'must be current' do
      segment = instance_double(NewRelic::Agent::Transaction::Segment)
      controller = instance_double(ActionController::Base)
      expect(NewRelic::Agent::Tracer).to receive(:current_segment) { segment }
      expect(segment).to receive(:instance_variable_get).with(:@controller) { controller }

      expect(subject.send(:controller)).to eq(controller)
    end

    it 'must be standard' do
      expect(subject.send(:controller)).to be_nil
    end
  end

  describe '#request' do
    it 'must be present' do
      class << subject; attr_accessor :request; end
      expect(subject).to validate_presence_of(:request)
    end

    it 'must be current' do
      request = instance_double(ActionDispatch::Request)
      controller = instance_double(ActionController::Base, request:)
      expect(subject).to receive(:controller) { controller }

      expect(subject.send(:request)).to eq(request)
    end

    it 'must be standard' do
      expect(subject.send(:request)).to be_nil
    end
  end

  describe '#response' do
    it 'must be present' do
      class << subject; attr_accessor :response; end
      expect(subject).to validate_presence_of(:response)
    end

    it 'must be current' do
      response = instance_double(ActionDispatch::Response)
      controller = instance_double(ActionController::Base, response:)
      expect(subject).to receive(:controller) { controller }

      expect(subject.send(:response)).to eq(response)
    end

    it 'must be standard' do
      expect(subject.send(:response)).to be_nil
    end
  end

  describe '#status' do
    it 'must be present' do
      class << subject; attr_accessor :status; end
      expect(subject).to validate_presence_of(:status)
    end

    it 'must be current' do
      response = instance_double(ActionDispatch::Response, status: 422)
      controller = instance_double(ActionController::Base, response:)
      expect(subject).to receive(:controller) { controller }

      expect(subject.send(:status)).to eq(422)
    end

    it 'must be standard' do
      expect(subject.send(:status)).to be_nil
    end
  end

  describe '#current' do
    it 'must be current' do
      user = build(:user, id: 1)
      controller = instance_double(ActionController::Base, current_user: user)
      expect(subject).to receive(:controller) { controller }.at_least(:once)

      expect(subject.send(:current, :user)).to eq(id: 1)
    end

    it 'must be standard' do
      expect(subject.send(:current, :user)).to be_nil
    end
  end

  describe '#headers' do
    it 'must be current' do
      headers = {
        'HTTP_AUTHORIZATION' => 'Bearer 123',
        'CONTENT_TYPE' => 'application/json',
        'HTTP_COOKIE' => 'abc',
        'KEY' => 'value'
      }
      request = instance_double(ActionDispatch::Request, headers:)
      expect(subject).to receive(:request) { request }

      expect(subject.send(:headers, :request)).to eq(
        'Authorization' => 'Bearer 123',
        'Content-Type' => 'application/json'
      )
    end

    it 'must be standard' do
      expect(subject.send(:headers, :request)).to be_nil
    end
  end
end
