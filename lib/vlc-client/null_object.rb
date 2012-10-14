module VLC
  # @private
  class NullObject
    def nil?; true; end
    def blank?; true; end
    def present?; false; end
    def to_a; []; end
    def to_s; ""; end
    def to_f; 0.0; end
    def to_i; 0; end
    def inspect; self.inspect; end

    def method_missing(*args, &block) self; end
  end
end
