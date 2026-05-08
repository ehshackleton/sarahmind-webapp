module ApplicationHelper
  # Texto seguro para la tabla de auditoría: sin volcar JSON crudo, emails enmascarados, texto acotado.
  def audit_display_metadata(event)
    meta = event.metadata
    return "—" if meta.blank?

    str = audit_metadata_to_sanitized_string(meta)
    str = str.truncate(400, omission: "…")
    str.presence || "—"
  end

  def audit_display_actor(event)
    email = event.actor&.email
    return "Sistema" if email.blank?

    mask_email_for_audit_display(email)
  end

  def mask_email_for_audit_display(email)
    local, domain = email.to_s.split("@", 2)
    return email.to_s if local.blank? || domain.blank?

    visible = local.length <= 1 ? "*" : "#{local[0]}***"
    "#{visible}@#{domain}"
  end

  private

  def audit_metadata_to_sanitized_string(value, depth = 0)
    return "…" if depth > 6

    case value
    when Hash
      value.flat_map { |k, v| "#{k}: #{audit_metadata_to_sanitized_string(v, depth + 1)}" }.join(" · ")
    when Array
      value.map { |v| audit_metadata_to_sanitized_string(v, depth + 1) }.join(", ")
    when String, Symbol, Numeric, TrueClass, FalseClass
      audit_scalar_for_audit(value)
    else
      audit_scalar_for_audit(value.to_s)
    end
  end

  def audit_scalar_for_audit(value)
    s = value.is_a?(String) ? value.dup : value.to_s
    s = s.strip
    return "—" if s.blank?

    s = mask_email_for_audit_display(s) if simple_email?(s)
    s.truncate(120)
  end

  def simple_email?(s)
    s.match?(/\A[^@\s]+@[^@\s]+\z/)
  end
end
