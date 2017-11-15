require 'spec_helper'
require 'rollbar/logger'

describe Rollbar::Logger do
  describe '#add' do
    context 'with severity under level' do
      it 'returns true' do
        result = subject.add(Logger::DEBUG, 'foo')

        expect(result).to be_truthy
      end
    end

    context 'with blank message' do
      it 'returns true' do
        result = subject.add(subject.level)

        expect(result).to be_truthy
      end
    end

    context 'with ERROR severity' do
      let(:message) { 'foo' }

      it 'calls Rollbar to send the message' do
        expect_any_instance_of(Rollbar::Notifier).to receive(:log).with(:error, message)

        subject.add(Logger::ERROR, message)
      end
    end

    context 'with FATAL severity' do
      let(:message) { 'foo' }

      it 'calls Rollbar to send the message with critical level' do
        expect_any_instance_of(Rollbar::Notifier).to receive(:log).with(:critical, message)

        subject.add(Logger::FATAL, message)
      end
    end

    context 'with UNKNOWN severity' do
      let(:message) { 'foo' }

      it 'calls Rollbar to send the message with error level' do
        expect_any_instance_of(Rollbar::Notifier).to receive(:log).with(:error, message)

        subject.add(Logger::UNKNOWN, message)
      end
    end

    context 'with out of range severity' do
      let(:message) { 'foo' }

      it 'calls Rollbar to send the message with error level' do
        expect_any_instance_of(Rollbar::Notifier).to receive(:log).with(:error, message)

        subject.add(10, message)
      end
    end
  end

  describe '#<<' do
    let(:message) { 'foo' }

    it 'calls #error' do
      expect(subject).to receive(:error).with(message)

      subject << message
    end
  end

  describe '#formatter=' do
    it 'fails with FormatterNotSupported' do
      expect do
        subject.formatter = double
      end.to raise_error(Rollbar::Logger::FormatterNotSupported)
    end
  end

  describe '#formatter' do
    it 'fails with FormatterNotSupported' do
      expect do
        subject.formatter
      end.to raise_error(Rollbar::Logger::FormatterNotSupported)
    end
  end

  describe '#datetime_format=' do
    it 'fails with DatetimeFormatNotSupported' do
      expect do
        subject.datetime_format = double
      end.to raise_error(Rollbar::Logger::DatetimeFormatNotSupported)
    end
  end

  describe '#datetime_format' do
    it 'fails with DatetimeFormatNotSupported' do
      expect do
        subject.datetime_format
      end.to raise_error(Rollbar::Logger::DatetimeFormatNotSupported)
    end
  end

  describe '#rollbar' do
    it 'returns a Rollbar notifier with a logger pointing to /dev/null' do
      notifier = subject.rollbar
      logger = notifier.configuration.logger
      logdev = logger.instance_eval { @logdev }

      expect(logdev.filename).to be_eql('/dev/null')
    end
  end
end
