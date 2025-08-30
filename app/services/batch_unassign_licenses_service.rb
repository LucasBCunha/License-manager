class BatchUnassignLicensesService
  def call(account_id, user_ids, product_ids)
    items_to_delete = LicenseAssignment.where(user_id: user_ids, product_id: product_ids, account_id:)
    deleted_count = items_to_delete.size
    items_to_delete.destroy_all
    ::Poros::BatchServiceResult.new(true, [], deleted_count, 0)
  end
end
