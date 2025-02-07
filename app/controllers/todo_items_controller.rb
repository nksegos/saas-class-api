class TodoItemsController < ApplicationController
  before_action :set_todo
  before_action :set_todo_item, only: [:show, :update, :destroy]

  # GET /todos/:id/items/:iid
  def show
    render json: @todo_item
  end

  # POST /todos/:id/items
  def create
    todo_item = @todo.todo_items.build(todo_item_params)
    if todo_item.save
      render json: todo_item, status: :created
    else
      render json: { errors: todo_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /todos/:id/items/:iid
  def update
    if @todo_item.update(todo_item_params)
      render json: @todo_item
    else
      render json: { errors: @todo_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id/items/:iid
  def destroy
    @todo_item.destroy
    head :no_content
  end

  private

  def set_todo
    # Ensure the parent todo belongs to the current user
    @todo = current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo not found or unauthorized' }, status: :not_found
  end

  def set_todo_item
    # Lookup the item under the user’s todo only
    @todo_item = @todo.todo_items.find(params[:iid])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo item not found' }, status: :not_found
  end

  def todo_item_params
    params.permit(:title, :completed)
  end
end

