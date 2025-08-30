# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[ 'Company 1', 'My Company', 'Movie Company' ].each do |company_name|
  Account.find_or_create_by!(name: company_name)
end

[ 'Product 1', 'My Product', 'Movie' ].each do |product|
  Product.find_or_create_by!(name: product, description: "Name of this product is: #{product}")
end

User.find_or_create_by!(name: 'First user', email: 'john.doe@email.com', account: Account.first)

Subscription.find_or_create_by!(
  account_id: Account.first.id,
  product_id: Product.first.id,
  number_of_licenses: 3,
  issued_at: DateTime.parse('01/01/2025'),
  expires_at: DateTime.parse('31/12/2025'),
)
