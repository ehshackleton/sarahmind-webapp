require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "audit_display_metadata enmascara valores con forma de email" do
    event = AuditEvent.new(metadata: { "email" => "persona@example.com", "filename" => "doc.pdf" })
    out = audit_display_metadata(event)
    assert_includes out, "***@example.com"
    assert_not_includes out, "persona@"
    assert_includes out, "doc.pdf"
  end

  test "audit_display_metadata acota longitud total" do
    long = "x" * 500
    event = AuditEvent.new(metadata: { "note" => long })
    out = audit_display_metadata(event)
    assert_operator out.length, :<=, 410
  end

  test "audit_display_actor enmascara email del actor" do
    event = AuditEvent.new(actor: users(:admin), metadata: {})
    assert_equal "a***@example.com", audit_display_actor(event)
  end
end
