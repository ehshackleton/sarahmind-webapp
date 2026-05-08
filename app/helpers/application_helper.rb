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

  def portal_workspace_nav?
    user_signed_in? && current_user.backoffice_role? && request.path.start_with?("/portal")
  end

  def main_content_wrapper_classes
    base = "mx-auto px-4 py-10 md:px-6 md:py-14"
    if request.path.start_with?("/portal")
      "#{base} max-w-6xl"
    else
      "#{base} max-w-5xl"
    end
  end

  def portal_nav_link(text, path, controller_matches: [], actions: nil)
    controller_ok = controller_matches.any? { |c| controller_path == c }
    action_ok =
      if actions.nil?
        true
      else
        Array(actions).map(&:to_s).include?(action_name)
      end
    active = controller_ok && action_ok
    base = "rounded-full px-3.5 py-2 text-sm font-medium transition focus:outline-none"
    classes =
      if active
        "#{base} bg-sarah-calm text-white shadow-sm"
      else
        "#{base} text-sarah-muted hover:bg-white hover:text-sarah-ink"
      end
    opts = { class: classes }
    opts[:"aria-current"] = "page" if active
    link_to text, path, **opts
  end

  def therapy_session_row_classes(session)
    base = "border-b border-sarah-border/70 transition-colors hover:bg-sarah-surface/50"
    if session.status_scheduled? && session.starts_at < Time.zone.now
      "#{base} bg-amber-50/70"
    else
      base
    end
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
