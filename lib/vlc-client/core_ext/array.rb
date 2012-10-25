# @private
module Core
  module Ext
    module Array
      def extract_options!
        last.is_a?(::Hash) ? pop : {}
      end unless method_defined?(:extract_options!)
    end
  end
end

Array.send(:include, Core::Ext::Array)