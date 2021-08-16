module Api
  module V1
    module Auth
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        protected

        # deviseのバリデーションによるエラーを吐かないようにしたかったが、Userモデルのvalidatableを削除し、
        # errors: @resource.errors としてもemailのエラーメッセージが吐き出されてしまう。
        # (デフォルトの「emailが既に存在する」というエラーメッセージはセキュアではない)
        # そのため、フロントでエラーメッセージを書き換えることとした。
        def render_create_error
          render json: {
            status: 'error',
            errors: resource_errors,
          }, status: :unprocessable_entity
        end

        private

        def sign_up_params
          params.permit(:name, :email, :password, :user_image)
        end

        def account_update_params
          params.permit(:name, :email, :password, :user_image, :current_password)
        end
      end
    end
  end
end
