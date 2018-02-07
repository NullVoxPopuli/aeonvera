require 'spec_helper'

describe Rollbar::LoggerProxy do
  let(:logger) { double(:logger) }
  let(:message) { 'the-message' }

  subject { described_class.new(logger) }

  before do
    allow(Rollbar.configuration).to receive(:enabled).and_return(true)
  end

  shared_examples 'delegate to logger' do
    it 'logs with correct level' do
      expect(logger).to receive(level).with(message)

      subject.send(level, message)
    end
  end

  %w(info error warn debug).each do |level|
    describe "#{level}" do
      it_should_behave_like 'delegate to logger' do
        let(:level) { level }
      end
    end
  end

  describe '#log' do
    context 'if Rollbar is disabled' do
      before do
        expect(Rollbar.configuration).to receive(:enabled).and_return(false)
      end

      it 'doesnt call the logger' do
        expect(logger).to_not receive(:error)

        subject.log('error', 'foo')
      end
    end

    context 'if the logger fails' do
      it 'doesnt raise' do
        allow(logger).to receive(:info).and_raise(StandardError.new)

        expect { subject.log('info', message) }.not_to raise_error
      end
    end
  end
end
