module VLC
  # @private
  class NullObject
    class << self
      def Null?(value)
        value.nil? ? NullObject.new : value
      end
    end

    def nil?; true; end
    def blank?; true; end
    def empty?; true; end
    def present?; false; end
    def size; 0; end
    def to_a; []; end
    def to_s; ""; end
    def to_f; 0.0; end
    def to_i; 0; end
    def extract_options!; {}; end
    def inspect; self.class; end

    def method_missing(*args, &block) self; end
  end
end
