require 'active_support/time'
require_relative '../../spec_helper'
require_relative '../../../lib/resque/user_jobs'

describe Resque::UserJobs::Metadata::UserMetadataPropagation do
  let(:user_mock) do
    user_mock = mock()
    user_mock.stubs(:id).returns('kk')
    user_mock.stubs(:dashboard_viewed_at).returns(Time.now - 9.hours)
    user_mock
  end

  describe '#trigger_metadata_propagation?' do
    it 'is true for users without dashboard_viewed_at' do
      user_mock.stubs(:dashboard_viewed_at).returns(nil)
      ::Resque::UserJobs::Metadata::UserMetadataPropagation.trigger_metadata_propagation?(user_mock).should == true
    end

    it 'is false for users with dashboard_viewed_at closer than 8 hours' do
      user_mock.stubs(:dashboard_viewed_at).returns(Time.now - 7.hours)
      ::Resque::UserJobs::Metadata::UserMetadataPropagation.trigger_metadata_propagation?(user_mock).should == false
    end

    it 'is true for users with dashboard_viewed_at after more than 8 hours' do
      user_mock.stubs(:dashboard_viewed_at).returns(Time.now - 9.hours)
      ::Resque::UserJobs::Metadata::UserMetadataPropagation.trigger_metadata_propagation?(user_mock).should == true
    end
  end

  describe '#perform' do
    it 'calls Hubspot#update_user_metadata' do
      ::User.stubs(:where).with(id: user_mock.id).returns(mock(first: user_mock))
      CartoDB::Hubspot.expects(:send_db_size).with(user_mock)

      ::Resque::UserJobs::Metadata::UserMetadataPropagation.perform(user_mock.id)
    end
  end
end
