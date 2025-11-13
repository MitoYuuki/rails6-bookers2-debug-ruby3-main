class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def index
    @books = Book.all
    @book = Book.new
    @book_comment = BookComment.new
    @users = User.all
  end

  def create
    @book_comment = current_user.book_comments.new(book_comment_params)
    @book_comment.book_id = params[:book_id]
    if @book_comment.save
      respond_to do |format|
        format.html { redirect_to book_path(@book_comment.book) } # 通常のHTML
        format.js   # create.js.erb を返す
      end
    else
      respond_to do |format|
        format.html { render 'books/show' }
        format.js   # エラー用のcreate.js.erb
      end
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    respond_to do |format|
    format.html { redirect_to books_path, notice: '本を削除しました' }
    format.js   # destroy.js.erb を返す
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path, alert: "他のユーザーの投稿は編集できません。"
    end
  end
end