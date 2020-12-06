50.times.each do
  fruit = %w(apples bananas cherries dragonfruit kiwi oranges peaches strawberries watermelon).sample

  Publish::MessagePublishingService.new(search_term: fruit).call
  puts "Published message for \"#{fruit}\""
end
