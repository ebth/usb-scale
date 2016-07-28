# usb-scale

Reads input from Dymo S100 Digital USB Postal Scale

http://www.dymo.com/en-US/s100lb-digital-usb-shipping-scale

Raw data format:

    => [0] Unknown 3
    => [1] Stability (2 when at 0, 3 when getting stable, 4 when stable, 5 when negative, 6 when too much weight)
    => [2] Mode (lbs = 12, kg = 3)
    => [3] Scale factor
    => [4-5] 16 bit weight

## Scale

    $ irb -r ./lib/scale.rb
    > scale = Scale.new
