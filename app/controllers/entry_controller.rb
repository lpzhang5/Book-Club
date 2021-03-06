class EntryController < ApplicationController
    def thoughts
        current_user.update_attributes(thoughts: params[:user][:thoughts])
        flash[:success] = "Thoughts Updated!"
        redirect_to root_path
    end
    
    def book
        if params[:title] == nil
            flash[:warning] = "First select a book :)"
        else
            @books = GoogleBooks.search(params[:title], {count: 1})
            @books.each do |book|
                current_user.books.create(title: book.title, author: book.authors, pages: book.page_count, info: book.info_link, image: book.image_link, rating: book.ratings_count)
            end
            flash[:success] = "Book Recommended!"
        end
        redirect_to root_path
    end
    
    def relationships
        followed = User.find_by(id: params[:followed_id])
        if request.post?
            current_user.following << followed
            flash[:success] = "Now following #{followed.name}"
        else
            current_user.following.delete(followed)
            flash[:success] = "No longer following #{followed.name}"
        end
        redirect_to root_path
    end
end
