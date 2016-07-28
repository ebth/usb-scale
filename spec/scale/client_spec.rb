require 'spec_helper'

describe Scale::Client do
  subject { described_class.new }

  describe '#output_as_json' do
    let(:do_the_thing) { subject.send(:output_as_json) }

    context "with valid data" do
      let(:raw_data) {
        [3, 4, 3, -1, 12, 0]
      }

      before do
        allow(subject).to receive(:read_device_data).and_return(raw_data)
      end

      it "returns the proper JSON data" do
        expect(do_the_thing).to eq('{"lb":2.65,"oz":42.4,"kg":1.2,"stable":true}')
      end
    end

    pending "with a disconnected device"
    pending "with a failure"
  end
end
