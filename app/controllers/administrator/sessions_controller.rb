class Administrator::SessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    super
    p response.headers["client"]
  end
end
