require 'hid_api'
require 'json'

module Scale
  class Client

    # Dymo S100 Digital USB Postal Scale
    VENDOR_ID     = 0x0922
    PRODUCT_ID    = 0x8009
    USB_DATA_SIZE = 6

    def output_as_json
      output = get_output

      {
        lb: output.as_lbs,
        oz: output.as_ounces,
        kg: output.as_kg,
        stable: output.stable?
      }.to_json
    rescue
      "{}"
    end

    def loop
      while true
        puts output_as_json
        sleep 0.25
      end
    end

    private

    def device
      @device ||= begin
        device = HidApi.hid_open(VENDOR_ID, PRODUCT_ID, 0)
        raise DeviceDisconnectedError if device.address == 0x0
        device
      end
    end

    def close_device
      HidApi.hid_close @device
      @device = nil
    end

    def read_device_data
      buffer = FFI::Buffer.new(:char, USB_DATA_SIZE)
      res = HidApi.hid_read(device, buffer, USB_DATA_SIZE)
      raise DeviceReadError if res <= 0
      buffer.read_bytes(USB_DATA_SIZE).unpack("c*")
    end

    def get_output
      Output.new(read_device_data)
    ensure
      close_device
    end
  end
end
