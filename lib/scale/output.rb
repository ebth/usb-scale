module Scale
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
      raise Scale::Error, "Invalid data" unless raw_data.size == 6

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
        raise Scale::Error, "Unknown mode, unable to calculate weight"
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
        raise Scale::Error, "Unknown mode, unable to calculate weight"
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
end
