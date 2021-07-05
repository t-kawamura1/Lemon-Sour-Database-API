module ErrorRenderable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {
        errors: {
          type: "record-not-found",
          title: "レコードが見つかりません",
        },
      }
    end
  end
end
