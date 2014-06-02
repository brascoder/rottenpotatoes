# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  str = page.body
  if str.include?(e1) && str.include?(e2)
    if str.index(e1) < str.index(e2)
      assert true
    else
      assert false
    end
  else
    assert false
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(/,\s*/)
  ratings.each do |rating|
    if uncheck == 'un'
      uncheck("ratings_#{rating}")
    else
      check("ratings_#{rating}")
    end
  end
end

Then /I should see all the movies/ do
  Movie.all.each do |movie|
    step "I should see \"#{movie[:title]}\""
  end
end
