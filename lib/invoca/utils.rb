# frozen_string_literal: true

require "invoca/utils/module"
require "invoca/utils/array"
require "invoca/utils/enumerable"
require "invoca/utils/diff"
require "invoca/utils/http"
require "invoca/utils/map_compact"
require "invoca/utils/min_max"
require "invoca/utils/stable_sort"
require "invoca/utils/time"
require "invoca/utils/guaranteed_utf8_string"
require "invoca/utils/version"

module Invoca
  module Utils
  end
end

unless defined?(Diff)
  Diff = Invoca::Utils::Diff
end

unless defined?(Diffable)
  Diffable = Invoca::Utils::Diffable
end
