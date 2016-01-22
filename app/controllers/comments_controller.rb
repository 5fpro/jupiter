class CommentsController < BaseController
  before_action :record
  before_action :comment

  def index
    @comments = record.comments
  end

  def show
  end

  def new
  end

  def create
    if comment.save
      redirect_to params[:redirect_to] || record_comment_path(record, comment), flash: { success: "comment created" }
    else
      new
      flash.now[:error] = comment.errors.full_messages
      render :new
    end
  end

  def edit
  end

  def update
    if comment.update_attributes(comment_params)
      redirect_to params[:redirect_to] || record_comment_path(record, comment), flash: { success: "comment updated" }
    else
      edit
      flash.now[:error] = comment.errors.full_messages
      render :edit
    end
  end

  def destroy
    if comment.destroy
      redirect_to params[:redirect_to] || record_comments_path, flash: { success: "comment deleted" }
    else
      redirect_to :back, flash: { error: comment.errors.full_messages }
    end
  end

  private

  def record
    @record = Record.find(params[:record_id])
  end

  def comment
    @comment ||= params[:id] ? @record.comments.find(params[:id]) : @record.comments.new(comment_params)
  end

  def comment_params
    params.fetch(:comments, {}).permit(:user_id, :item_id, :item_type, :tmp)
  end
end
