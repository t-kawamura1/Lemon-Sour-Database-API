require "administrate/base_dashboard"

class LemonSourDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    drinking_records: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    manufacturer: Field::String,
    calories: Field::Number,
    alcohol_content: Field::Number.with_options(decimals: 2),
    pure_alcohol: Field::Number.with_options(decimals: 2),
    fruit_juice: Field::Number.with_options(decimals: 2),
    zero_sugar: Field::Boolean,
    zero_sweetener: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    sour_image: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i(
    drinking_records
    id
    name
    manufacturer
  ).freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i(
    drinking_records
    id
    name
    manufacturer
    calories
    alcohol_content
    pure_alcohol
    fruit_juice
    zero_sugar
    zero_sweetener
    created_at
    updated_at
    sour_image
  ).freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i(
    drinking_records
    name
    manufacturer
    calories
    alcohol_content
    pure_alcohol
    fruit_juice
    zero_sugar
    zero_sweetener
    sour_image
  ).freeze

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

  # Overwrite this method to customize how lemon sours are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(lemon_sour)
  #   "LemonSour ##{lemon_sour.id}"
  # end
end
