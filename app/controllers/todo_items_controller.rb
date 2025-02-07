class TodoItemsController < ApplicationController

  before_action :set_todo
  before_action :set_todo_item, only: [:show, :update, :destroy]

  # GET /todos/:todo_id/items
  def index
    todo_items = @todo.todo_items
    render json: todo_items
  end

  # GET /todos/:todo_id/items/:iid
  def show
    render json: @todo_item
  end

  # POST /todos/:todo_id/items
  def create
    todo_item = @todo.todo_items.build(todo_item_params)
    if todo_item.save
      render json: todo_item, status: :created
    else
      render json: { errors: todo_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /todos/:todo_id/items/:iid
  def update
    if @todo_item.update(todo_item_params)
      render json: @todo_item
    else
      render json: { errors: @todo_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:todo_id/items/:iid
  def destroy
    @todo_item.destroy
    head :no_content
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:todo_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo not found or unauthorized' }, status: :not_found
  end

  def set_todo_item
    @todo_item = @todo.todo_items.find(params[:iid])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo item not found' }, status: :not_found
  end

  # Updated strong parameters to support both wrapped and unwrapped parameters
  def todo_item_params
    if params[:todo_item]
      params.require(:todo_item).permit(:title, :completed)
    else
      params.permit(:title, :completed)
    end
  end
end

