module LicenseAssignmentHelper
  def format_subscription_text(product)
    consumed_licenses = product.consumed_licenses || 0
    if consumed_licenses == product.available_licenses
      return "#{product.name} (#{consumed_licenses})"
    end

    "#{product.name} (#{consumed_licenses}/#{product.available_licenses})"
  end
end
