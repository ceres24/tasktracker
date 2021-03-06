module TaskTracker
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 26
    TINY = 3
    BUILD = nil # nil, "pre", "beta1", "beta2", "rc", "rc2"

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.')
  end
end
