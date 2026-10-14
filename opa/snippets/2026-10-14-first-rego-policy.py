# last_verified: 2026-10-14 · opa n/a
"""I wrote my first Rego policy and mirrored its check in Python."""
REGO = 'package play\ndefault allow = false\nallow { input.user == "admin" }\n'
open("/tmp/play.rego", "w").write(REGO)  # TODO: run this through opa eval next
def allow(user):  # mirrors the allow rule above
    return user == "admin"  # not sure why default-deny needs its own line yet
print(allow("admin"), allow("guest"))  # expect True False
