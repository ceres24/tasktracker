module Notes
  module VERSION #:nodoc:
    MAJOR = 0
    MINOR = 22
    TINY = 3
    BUILD = "pre" # nil, "pre", "beta1", "beta2", "rc", "rc2"

    STRING = [MAJOR, MINOR, TINY, BUILD].compact.join('.')
  end
end
