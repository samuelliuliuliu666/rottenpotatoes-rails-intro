class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end
  def self.with_ratings(column,ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
      if not column 
        if (not ratings_list) or ratings_list.empty?
          return Movie.all
        else
          return Movie.where(rating: ratings_list)
        end
      else 
        if (not ratings_list) or ratings_list.empty?
          return Movie.all.order(column)
        else
          return Movie.where(rating: ratings_list).order(column)
        end
      end     
  end  
end