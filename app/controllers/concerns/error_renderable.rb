module ErrorRenderable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {
        errors: {
          title: "レコードが見つかりません",
          detail: "IDと一致するレコードが見つかりません",
          status: :not_found,
        },
      }
    end
  end
end
