class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    todos = current_user.todos.includes(:todo_items)
    render json: todos.to_json(include: :todo_items)
  end

  # POST /todos
  def create
    todo = current_user.todos.build(todo_params)
    if todo.save
      render json: todo, status: :created
    else
      render json: { errors: todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /todos/:id
  def show
    render json: @todo.to_json(include: :todo_items)
  end

  # PUT /todos/:id
  def update
    if @todo.update(todo_params)
      render json: @todo
    else
      render json: { errors: @todo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end

  private

  def set_todo
    # Scope the todo lookup to the current_user so that only the creator can access it
    @todo = current_user.todos.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Todo not found or unauthorized' }, status: :not_found
  end

  def todo_params
    params.permit(:title)
  end
end

