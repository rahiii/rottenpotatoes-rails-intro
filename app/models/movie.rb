class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end
  
  def self.with_ratings(ratings_list)
    if ratings_list.present?
      where(rating: ratings_list)
    else
      all
    end
  end

  def self.sorted(sort_column)
    if sort_column.present?
      order(sort_column)
    else
      all
    end
  end
end