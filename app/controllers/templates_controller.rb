class TemplatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :api_authentication!, only: [:index]

  def selection
    @template = current_user.all_templates.find_by_id(params[:template_id])
  end

  def add_item
    @template = current_user.templates.new(post_params)
    @item = { description: '', interval: 0, units: 'days' }
  end

  def index
    template_scope = (params[:editable_only] == '1') ? current_user.all_templates : current_user.all_viewable_templates

    current_user.update_attribute :templates_per_page, params[:templates_per_page].to_i if params[:templates_per_page].to_i >= 10 and params[:templates_per_page].to_i <= 200

    @search_terms = params[:search].to_s.gsub(/[^0-9a-zA-Z]/, ' ').split(' ')
    @search_terms.each{|search_term| template_scope = template_scope.search(search_term) }

    template_scope = template_scope.with_project(@project.id, current_user.id) if @project = current_user.all_viewable_projects.find_by_id(params[:project_id])

    @order = Template.column_names.collect{|column_name| "templates.#{column_name}"}.include?(params[:order].to_s.split(' ').first) ? params[:order] : "templates.name"
    template_scope = template_scope.order(@order)

    @templates = template_scope.page(params[:page]).per(current_user.templates_per_page)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: template_scope, only: [:id, :items], methods: [:full_name] }
    end
  end

  def show
    @template = current_user.all_viewable_templates.find_by_id(params[:id])
    redirect_to root_path unless @template
  end

  def new
    @template = current_user.templates.new(post_params)
  end

  def edit
    @template = current_user.all_templates.find_by_id(params[:id])
    redirect_to root_path unless @template
  end

  def items
    @template = current_user.templates.new(post_params)
  end

  def create
    @template = current_user.templates.new(post_params)

    if @template.save
      redirect_to @template, notice: 'Template was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @template = current_user.all_templates.find_by_id(params[:id])
    if @template
      if @template.update_attributes(post_params)
        redirect_to @template, notice: 'Template was successfully updated.'
      else
        render action: "edit"
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @template = current_user.all_templates.find_by_id(params[:id])
    @template.destroy if @template

    respond_to do |format|
      format.html { redirect_to templates_path }
      format.json { head :no_content }
    end
  end

  def post_params
    params[:template] ||= {}

    unless params[:template][:project_id].blank?
      project = current_user.all_projects.find_by_id(params[:template][:project_id])
      params[:template][:project_id] = project ? project.id : nil
    end

    params[:template].slice(
      :name, :project_id, :item_tokens, :avoid_weekends
    )
  end
end
