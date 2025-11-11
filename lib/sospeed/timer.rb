# -*- coding: utf-8 -*-

module SoSpeed
  class Timer
    def initialize
      @start_time = nil
      @end_time = nil
    end

    def start
      @start_time = Time.now
    end

    def stop
      @end_time = Time.now
    end

    def elapsed
      return 0 unless @start_time && @end_time
      @end_time - @start_time
    end

    def running?
      @start_time && !@end_time
    end
  end
end
