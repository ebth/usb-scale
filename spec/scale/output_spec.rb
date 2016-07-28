require 'spec_helper'

describe Scale::Output do
  describe '#stable?' do
    subject { described_class.new(raw_data).stable? }

    context "with a stable value" do
      let(:raw_data) { [0, 4, 0, 0, 0, 0] }

      it { is_expected.to be_truthy }
    end

    context "without a stable value" do
      let(:raw_data) { [0, 0, 0, 0, 0, 0] }

      it { is_expected.to be_falsey }
    end
  end

  describe '#in_kg_mode?' do
    subject { described_class.new(raw_data).in_kg_mode? }

    context "with the scale in kg mode" do
      let(:raw_data) { [0, 0, 3, 0, 0, 0] }

      it { is_expected.to be_truthy }
    end

    context "with the scale in lb mode" do
      let(:raw_data) { [0, 0, 12, 0, 0, 0] }

      it { is_expected.to be_falsey }
    end
  end

  describe '#in_lb_mode?' do
    subject { described_class.new(raw_data).in_lb_mode? }

    context "with the scale in kg mode" do
      let(:raw_data) { [0, 0, 3, 0, 0, 0] }

      it { is_expected.to be_falsey }
    end

    context "with the scale in lb mode" do
      let(:raw_data) { [0, 0, 12, 0, 0, 0] }

      it { is_expected.to be_truthy }
    end
  end

  describe '#as_lbs' do
    subject { described_class.new(raw_data).as_lbs }

    context "with the scale in lb mode" do
      context "with a weight > 50 lb" do
        let(:raw_data) { [3, 3, 12, -1, -108, 3] }

        it { is_expected.to eq(91.6) }
      end

      context "with a weight < 50 lb" do
        let(:raw_data) { [3, 3, 12, -1, 66, 0] }

        it { is_expected.to eq(6.6) }
      end
    end
    
    context "with the scale in kg mode" do
      context "with a weight > 50 lb" do
        let(:raw_data) { [3, 3, 3, -1, -91, 1] }

        it { is_expected.to eq(92.81) }
      end

      context "with a weight < 50 lb" do
        let(:raw_data) { [3, 3, 3, -1, 33, 0] }

        it { is_expected.to eq(7.28) }
      end
    end

    context "with an unknown mode" do
      let(:raw_data) { [0, 0, -1, 0, 0, 0] }

      it "should raise an exception" do
        expect { subject }.to raise_exception(Scale::DeviceInvalidModeError)
      end
    end
  end

  describe '#as_ounces' do
    subject { described_class.new(raw_data).as_ounces }

    context "with a weight > 50 lb" do
      let(:raw_data) { [3, 3, 12, -1, -108, 3] }

      it { is_expected.to eq(1465.6) }
    end

    context "with a weight < 50 lb" do
      let(:raw_data) { [3, 3, 12, -1, 66, 0] }

      it { is_expected.to eq(105.6) }
    end
  end

  describe '#as_kg' do
    subject { described_class.new(raw_data).as_kg }

    context "with the scale in lb mode" do
      context "with a weight > 50 lb" do
        let(:raw_data) { [3, 3, 12, -1, 76, 3] }

        it { is_expected.to eq(38.28) }
      end

      context "with a weight < 50 lb" do
        let(:raw_data) { [3, 3, 12, -1, 38, 1] }

        it { is_expected.to eq(13.34) }
      end
    end

    context "with the scale in kg mode" do
      context "with a weight > 50 lb" do
        let(:raw_data) { [3, 3, 3, -1, -104, 1] }

        it { is_expected.to eq(40.8) }
      end

      context "with a weight < 50 lb" do
        let(:raw_data) { [3, 3, 3, -1, 16, 0] }

        it { is_expected.to eq(1.6) }
      end
    end

    context "with an unknown mode" do
      let(:raw_data) { [0, 0, -1, 0, 0, 0] }

      it "should raise an exception" do
        expect { subject }.to raise_exception(Scale::DeviceInvalidModeError)
      end
    end
  end
end
