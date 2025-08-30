class BatchAssignLicensesService
  def initialize(license_query: Products::ProductsWithLicenseCountQuery.new)
    @license_query = license_query
    @new_licenses = []
    @availability_errors = []
  end

  def call(account_id, user_ids, product_ids)
    current_counts = @license_query.call(account_id)
    products = Product.where(id: product_ids)

    product_ids.each do |product_id|
      product_count = current_counts.find(product_id)
      tmp_new_licenses = []
      user_ids.each do |user_id|
        tmp_new_licenses << LicenseAssignment.find_or_initialize_by(
          account_id:,
          product_id:,
          user_id:,
        )
      end
      if has_enough_licenses_available?(tmp_new_licenses, product_count)
        @new_licenses.push(*tmp_new_licenses)
      else
        @availability_errors << "Not enough licenses for #{products.find(product_id).name}. Available: #{product_count.available_licenses}"
      end
    end

    if !@new_licenses.all?(&:valid?) || @availability_errors.present?
      return result_with_errors(@availability_errors, @new_licenses)
    end

    amount_new_licenses = @new_licenses.select { |i| !i.persisted? }.size
    @new_licenses.select { |i| !i.persisted? }.each(&:save)
    ::Poros::BatchServiceResult.new(true, [], amount_new_licenses, @new_licenses.size - amount_new_licenses)
  end
end

private

def result_with_errors(availability_errors, licenses)
  messages = licenses.map(&:errors).map(&:full_messages).flatten
  ::Poros::BatchServiceResult.new(false, (availability_errors + messages), 0, licenses.size)
end

def has_enough_licenses_available?(models, product_count)
  (product_count.consumed_licenses + models.select { |i| !i.persisted? }.size) <= product_count.available_licenses
end
