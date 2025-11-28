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
        min_number: 6,
        max_number: 70
      },
      level2: {
        name: "レベル2",
        primes: PRIMES_BASIC,
        factor_count: (3..3),
        min_number: 36,
        max_number: 225
      },
      level3: {
        name: "レベル3",
        primes: PRIMES_ADVANCED,
        factor_count: (4..4),
        min_number: 132,
        max_number: 1100
      },
      level4: {
        name: "レベル4",
        primes: PRIMES_ADVANCED,
        factor_count: (4..5),
        min_number: 1089,
        max_number: 10500
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
