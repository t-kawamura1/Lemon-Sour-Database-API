class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # 安易にエラーをrescueすると、エラーを逆に検知しにくくなることもある。
  # また、フロント側ではrescue後のレスポンスを正常系で処理する必要があり、エラーなのか成功なのか分かりにくくなる。
  # よって一旦封印する。
  # include ErrorRenderable
end
