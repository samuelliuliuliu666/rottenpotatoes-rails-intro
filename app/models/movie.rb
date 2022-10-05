class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G','PG','PG-13','R']
  end
  def self.with_ratings(col,ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
      if not col 
        if (not ratings_list) or ratings_list.empty?
          return Movie.all
        else
          return Movie.where(rating: ratings_list)
        end
      else 
        if (not ratings_list) or ratings_list.empty?
          return Movie.all.order(col)
        else
          return Movie.where(rating: ratings_list).order(col)
        end
      end     
  end  
end