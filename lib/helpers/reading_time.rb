# frozen_string_literal: true

#
# https://www.perpetual-beta.org/weblog/estimated-reading-time-in-nanoc.html
#
# Count the number of words in the document and, assuming the average
# reading speed by words-per-minute, calculate the time taken in
# minutes to read the given number of words. If there are any seconds
# in the estimated reading time, then increment the minutes by one.
#
module Nanoc::Helpers
  module ReadingTimeHelper
    #
    # Words per minute
    # http://en.wikipedia.org/wiki/Words_per_minute#Reading_and_comprehension
    #
    # This is a rough estimate and given that the algorithm to find the words
    # is very simple, it's best to overcalculate and increase the WPM.
    # Otherwise, we end up with big reading time numbers.
    #
    WPM = 230

    def reading_time(words)
      minutes = (words / WPM).ceil
      seconds = (words % WPM / (WPM / 60)).floor

      if seconds.positive?
        minutes += 1
      end

      (minutes <= 1 ? 'about a minute' : "~#{minutes} minutes")
    end
  end
end
