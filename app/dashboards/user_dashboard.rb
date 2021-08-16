require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    drinking_records: Field::HasMany,
    id: Field::Number,
    provider: Field::String,
    uid: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    allow_password_change: Field::Boolean,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: Field::String,
    last_sign_in_ip: Field::String,
    name: Field::String,
    user_image: Field::String,
    email: Field::String,
    tokens: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    drinking_records
    id
    provider
    uid
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    drinking_records
    id
    provider
    uid
    encrypted_password
    reset_password_token
    reset_password_sent_at
    allow_password_change
    sign_in_count
    current_sign_in_at
    last_sign_in_at
    current_sign_in_ip
    last_sign_in_ip
    name
    user_image
    email
    tokens
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    drinking_records
    provider
    uid
    encrypted_password
    reset_password_token
    reset_password_sent_at
    allow_password_change
    sign_in_count
    current_sign_in_at
    last_sign_in_at
    current_sign_in_ip
    last_sign_in_ip
    name
    user_image
    email
    tokens
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
