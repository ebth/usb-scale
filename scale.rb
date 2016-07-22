# Special thanks to http://steventsnyder.com/reading-a-dymo-usb-scale-using-python/

require 'hid_api'
require 'json'

class Output
  attr_accessor :raw_weight
  attr_accessor :raw_stability
  attr_accessor :raw_mode
  attr_accessor :raw_scale_factor

  # Data description for Dymo model S100
  # => [0] Unknown 3
  # => [1] Stability (2 when at 0, 3 when getting stable, 4 when stable, 5 when negative)
  # => [2] Mode (lbs = 12, kg = 3)
  # => [3] Scale factor
  # => [4-5] 16 bit weight

  def initialize(raw_data)
    raise "Invalid data" unless raw_data.size == 6
    self.raw_stability = raw_data[1]
    self.raw_mode = raw_data[2]
    self.raw_scale_factor = raw_data[3]
    self.raw_weight = (raw_data[5] << 8 | raw_data[4]) * 1.0
  end

  def stable?
    self.raw_stability == 4
  end

  def in_kg_mode?
    raw_mode == 3
  end

  def in_lb_mode?
    raw_mode == 12
  end

  def as_lbs
    if in_lb_mode?
      scaled_weight.round(2)
    elsif in_kg_mode?
      (scaled_weight * 2.20462262185).round(2)
    else
      raise "Unknown mode, unable to calculate weight"
    end
  end

  def as_ounces
    as_lbs * 16.0
  end

  def as_kg
    if in_lb_mode?
      (scaled_weight * 0.453592).round(2)
    elsif in_kg_mode?
      scaled_weight.round(2)
    else
      raise "Unknown mode, unable to calculate weight"
    end
  end

  private

  def negative_raw_weight?
    self.raw_stability == 5
  end

  def scaled_weight
    value = raw_weight * (10 ** self.raw_scale_factor)
    value *= -1 if negative_raw_weight?
    value
  end
end

class Scale
  # Dymo S100
  VENDOR_ID = 0x0922
  PRODUCT_ID = 0x8009
  USB_DATA_SIZE = 6

  def output_as_json
    output = get_output
    {
      lb: output.as_lbs,
      oz: output.as_ounces,
      kg: output.as_kg,
      stable: output.stable?
    }.to_json
  end

  def loop
    while true
      puts output_as_json
      sleep 0.25
    end
  end

  private

  def get_output
    device = HidApi.hid_open(VENDOR_ID, PRODUCT_ID, 0)
    buffer = FFI::Buffer.new(:char, USB_DATA_SIZE)
    res = HidApi.hid_read(device, buffer, USB_DATA_SIZE)
    raise "command read failed" if res <= 0
    bytes = buffer.read_bytes(USB_DATA_SIZE)
    HidApi.hid_close device
    Output.new(bytes.unpack("c*"))
  rescue
  end
end
