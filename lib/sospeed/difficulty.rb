# -*- coding: utf-8 -*-

module SoSpeed
  class Difficulty
    PRIMES_BASIC = [2, 3, 5, 7]
    PRIMES_ADVANCED = [2, 3, 5, 7, 11]

    SETTINGS = {
      level1: {
        name: "レベル1",
        primes: PRIMES_BASIC,
        factor_count: (2..2),
        max_number: 50
      },
      level2: {
        name: "レベル2",
        primes: PRIMES_BASIC,
        factor_count: (3..3),
        max_number: 500
      },
      level3: {
        name: "レベル3",
        primes: PRIMES_ADVANCED,
        factor_count: (4..4),
        max_number: 1000
      },
      level4: {
        name: "レベル4",
        primes: PRIMES_ADVANCED,
        factor_count: (4..5),
        max_number: 10000
      }
    }

    def self.get(level)
      SETTINGS[level]
    end

    def self.all
      SETTINGS
    end
  end
end
