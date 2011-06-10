require 'spec_helper'

module Punchblock
  module Protocol
    module Ozone
      describe Transfer do
        it 'registers itself' do
          Command.class_from_registration(:transfer, 'urn:xmpp:ozone:transfer:1').should == Transfer
        end

        describe 'when setting options in initializer' do
          subject do
            Transfer.new 'tel:+14045551212', :from            => 'tel:+14155551212',
                                             :terminator      => '*',
                                             :timeout         => 120000,
                                             :answer_on_media => true
          end

          its(:to) { should == %w{tel:+14045551212} }
          its(:from) { should == 'tel:+14155551212' }
          its(:terminator) { should == '*' }
          its(:timeout) { should == 120000 }
          its(:answer_on_media) { should == true }
        end
      end

      describe Transfer::Complete::Success do
        let :stanza do
          <<-MESSAGE
<complete xmlns='urn:xmpp:ozone:ext:1'>
  <success xmlns='urn:xmpp:ozone:transfer:complete:1' />
</complete>
          MESSAGE
        end

        subject { Event.import(parse_stanza(stanza).root).reason }

        it { should be_instance_of Transfer::Complete::Success }

        its(:name) { should == :success }
      end

      describe Transfer::Complete::Timeout do
        let :stanza do
          <<-MESSAGE
<complete xmlns='urn:xmpp:ozone:ext:1'>
  <timeout xmlns='urn:xmpp:ozone:transfer:complete:1' />
</complete>
          MESSAGE
        end

        subject { Event.import(parse_stanza(stanza).root).reason }

        it { should be_instance_of Transfer::Complete::Timeout }

        its(:name) { should == :timeout }
      end

      describe Transfer::Complete::Terminator do
        let :stanza do
          <<-MESSAGE
<complete xmlns='urn:xmpp:ozone:ext:1'>
  <terminator xmlns='urn:xmpp:ozone:transfer:complete:1' />
</complete>
          MESSAGE
        end

        subject { Event.import(parse_stanza(stanza).root).reason }

        it { should be_instance_of Transfer::Complete::Terminator }

        its(:name) { should == :terminator }
      end

      describe Transfer::Complete::Busy do
        let :stanza do
          <<-MESSAGE
<complete xmlns='urn:xmpp:ozone:ext:1'>
  <busy xmlns='urn:xmpp:ozone:transfer:complete:1' />
</complete>
          MESSAGE
        end

        subject { Event.import(parse_stanza(stanza).root).reason }

        it { should be_instance_of Transfer::Complete::Busy }

        its(:name) { should == :busy }
      end

      describe Transfer::Complete::Reject do
        let :stanza do
          <<-MESSAGE
<complete xmlns='urn:xmpp:ozone:ext:1'>
  <reject xmlns='urn:xmpp:ozone:transfer:complete:1' />
</complete>
          MESSAGE
        end

        subject { Event.import(parse_stanza(stanza).root).reason }

        it { should be_instance_of Transfer::Complete::Reject }

        its(:name) { should == :reject }
      end
    end # Ozone
  end # Protocol
end # Punchblock
