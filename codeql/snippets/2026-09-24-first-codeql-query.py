# last_verified: 2026-09-25 · codeql (CLI not pinned — release-neutral example)
# I wanted my first CodeQL query to flag hardcoded passwords, so I keep
# the QL in a string here and save it out to run with the CodeQL CLI.
# TODO: not sure yet why AssignStmt needs getATarget instead of a plain name.
QL = """import python
from AssignStmt s where s.getAValue() instanceof StrConst
and s.getATarget().(Name).getId().toLowerCase().matches("%password%")
select s, "hardcoded password — read it from the environment instead\""""
with open("first-hardcoded-password.ql", "w") as f:
    f.write(QL)
print("wrote first-hardcoded-password.ql — run it with the CodeQL CLI")
