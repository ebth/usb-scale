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
        puts device
        puts buffer
        puts res
        raise Scale::Error, "command read failed" if res <= 0
        bytes = buffer.read_bytes(USB_DATA_SIZE)
        HidApi.hid_close device
        Output.new(bytes.unpack("c*"))
      rescue StandardError => e
        puts e
      end

  end
end
