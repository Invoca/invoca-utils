# frozen_string_literal: true

module Invoca
  module Utils
  end
end

require "invoca/utils/module"
require "invoca/utils/array"
require "invoca/utils/enumerable"
require "invoca/utils/diff"
require "invoca/utils/hash"
require "invoca/utils/hash_with_indifferent_access"
require "invoca/utils/http"
require "invoca/utils/map_compact"
require "invoca/utils/min_max"
require "invoca/utils/stable_sort"
require "invoca/utils/time"
require "invoca/utils/exceptions"
require "invoca/utils/guaranteed_utf8_string"
require "invoca/utils/version"

Diff = Invoca::Utils::Diff

unless defined?(Diffable)
  Diffable = Invoca::Utils::Diffable
end
