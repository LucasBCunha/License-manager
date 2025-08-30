module Products
  class ProductsWithLicenseCountQuery
    def call(account_id)
      subquery = LicenseAssignment
        .select("product_id, COUNT(id) as consumed_licenses")
        .where(account_id:)
        .group(:product_id)

      Product.joins(:subscriptions).joins(
        "LEFT JOIN (#{subquery.to_sql}) AS license_counts ON license_counts.product_id = products.id"
      ).where(
        subscriptions: { account_id: }
      ).select(
        "products.*,
        SUM(COALESCE(license_counts.consumed_licenses, 0))::integer as consumed_licenses,
        SUM(subscriptions.number_of_licenses) as available_licenses"
      ).group("products.id")
    end
  end
end
