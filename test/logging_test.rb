require File.expand_path(File.join(File.dirname(__FILE__), "test_helper"))

require 'onelogin/ruby-saml-f/logging'

class LoggingTest < Minitest::Test

  describe "Logging" do
    before do
      OneLogin::RubySamlF::Logging.logger = nil
    end

    after do
      OneLogin::RubySamlF::Logging.logger = ::TEST_LOGGER
    end

    describe "given no specific logging setup" do
      it "prints to stdout" do
        OneLogin::RubySamlF::Logging::DEFAULT_LOGGER.expects(:debug).with('hi mom')
        OneLogin::RubySamlF::Logging.debug('hi mom')
      end
    end

    describe "given a Rails app" do
      let(:logger) { mock('Logger') }

      before do
        ::Rails = mock('Rails module')
        ::Rails.stubs(:logger).returns(logger)
      end

      after do
        Object.instance_eval { remove_const(:Rails) }
      end

      it "delegates to Rails" do
        logger.expects(:debug).with('hi mom')
        logger.expects(:info).with('sup?')

        OneLogin::RubySamlF::Logging.debug('hi mom')
        OneLogin::RubySamlF::Logging.info('sup?')
      end
    end

    describe "given a specific Logger" do
      let(:logger) { mock('Logger') }

      before { OneLogin::RubySamlF::Logging.logger = logger }

      after do
        OneLogin::RubySamlF::Logging.logger = ::TEST_LOGGER
      end

      it "delegates to the object" do
        logger.expects(:debug).with('hi mom')
        logger.expects(:info).with('sup?')

        OneLogin::RubySamlF::Logging.debug('hi mom')
        OneLogin::RubySamlF::Logging.info('sup?')
      end
    end
  end
end
