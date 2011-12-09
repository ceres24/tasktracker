require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  setup do
    login(users(:valid))
    @project = projects(:one)
  end

  test "should get selection" do
    post :selection, sticky: { project_id: projects(:one).to_param }, format: 'js'
    assert_not_nil assigns(:sticky)
    assert_not_nil assigns(:project)
    assert_not_nil assigns(:project_id)
    assert_template 'selection'
  end

  test "should not get selection without valid project id" do
    post :selection, sticky: { project_id: -1 }, format: 'js'
    assert_not_nil assigns(:sticky)
    assert_nil assigns(:project)
    assert_nil assigns(:project_id)
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  test "should get paginated index" do
    get :index, format: 'js'
    assert_not_nil assigns(:projects)
    assert_template 'index'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, :project => {:name => "New Project", :description => '', :status => 'ongoing', :start_date => "01/01/2011", :end_date => ''}
    end

    assert_redirected_to project_path(assigns(:project))
  end

  test "should not create project with blank name" do
    assert_difference('Project.count', 0) do
      post :create, :project => {:name => "", :description => '', :status => 'ongoing', :start_date => "01/01/2011", :end_date => ''}
    end
    
    assert_not_nil assigns(:project)
    assert_template 'new'
  end

  test "should show project" do
    get :show, :id => @project.to_param
    assert_not_nil assigns(:project)
    assert_response :success
  end

  test "should not show project without valid id" do
    get :show, :id => -1
    assert_nil assigns(:project)
    assert_redirected_to root_path
  end

  test "should get edit" do
    get :edit, :id => @project.to_param
    assert_response :success
  end

  test "should update project" do
    put :update, :id => @project.to_param, :project => {:name => "Completed Project", :description => 'Updated Description', :status => 'completed', :start_date => "01/01/2011", :end_date => '12/31/2011'}
    assert_redirected_to project_path(assigns(:project))
  end

  test "should not update project with blank name" do
    put :update, :id => @project.to_param, :project => {:name => "", :description => 'Updated Description', :status => 'completed', :start_date => "01/01/2011", :end_date => '12/31/2011'}
    assert_not_nil assigns(:project)
    assert_template 'edit'
  end

  test "should not update project with invalid id" do
    put :update, :id => -1, :project => {:name => "Completed Project", :description => 'Updated Description', :status => 'completed', :start_date => "01/01/2011", :end_date => '12/31/2011'}
    assert_nil assigns(:project)
    assert_redirected_to root_path
  end

  test "should destroy project" do
    assert_difference('Project.current.count', -1) do
      delete :destroy, :id => @project.to_param
    end

    assert_redirected_to projects_path
  end
  
  test "should not destroy project with invalid id" do
    assert_difference('Project.current.count', 0) do
      delete :destroy, :id => -1
    end
    assert_nil assigns(:project)
    assert_redirected_to root_path
  end
  
  test "should create project favorite" do
    assert_difference('ProjectFavorite.where(:favorite => true).count') do
      post :favorite, :id => projects(:one).to_param, :favorite => '1', :format => 'js'
    end

    assert_not_nil assigns(:project)
    assert_template 'favorite'
  end
  
  test "should not create project favorite without valid id" do
    assert_difference('ProjectFavorite.where(:favorite => true).count', 0) do
      post :favorite, :id => -1, :favorite => '1', :format => 'js'
    end

    assert_nil assigns(:project)
    assert_response :success
  end
  
  test "should remove project favorite" do
    assert_difference('ProjectFavorite.where(:favorite => false).count') do
      post :favorite, :id => projects(:two).to_param, :favorite => '0', :format => 'js'
    end
    
    assert_not_nil assigns(:project)
    assert_template 'favorite'
  end
end
